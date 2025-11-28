#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# USAGE:
#   ./mosaic_make.sh INPUT.nc OUTPUT.nc
#
# DESCRIPTION:
#   Creates a "mosaic" file: 1° resolution over Europe but
#   preserving native resolution over the Po Valley region:
#
#       North = 46.5
#       West  = 7
#       South = 44
#       East  = 13
#
#   The output is on the native (fine) grid, so it can be used
#   directly in DATO and in your operators.
# ============================================================

if [[ $# -ne 2 ]]; then
    echo "Usage: ./mosaic_make.sh INPUT.nc OUTPUT.nc"
    exit 1
fi

INPUT="$1"
OUTPUT="$2"

# Region of interest (Po Valley)
N_PO=46.5
W_PO=7
S_PO=44
E_PO=13

# Temporary files
TMPDIR=$(mktemp -d)
COARSE_GRID="${TMPDIR}/grid_1deg.txt"
MASK_FINE="${TMPDIR}/mask_fine.nc"
MASK_COARSE="${TMPDIR}/mask_coarse.nc"
MASK_NATIVE="${TMPDIR}/mask_native.nc"
FINE_IN_PO="${TMPDIR}/fine_po.nc"
COARSE_WORLD="${TMPDIR}/coarse_world.nc"
COARSE_ON_NATIVE="${TMPDIR}/coarse_on_native.nc"
COARSE_OUTSIDE="${TMPDIR}/coarse_outside.nc"
FINE_PO_MASKED="${TMPDIR}/fine_po_masked.nc"

echo "Temporary directory: $TMPDIR"

# ============================================================
# 1. Create a 1° grid description file (Europe + Atlantic domain)
#    NOTE: Adjust domain if you change ERA5 download area.
# ============================================================

cat > "${COARSE_GRID}" <<EOF
gridtype = lonlat
xsize    = 76
ysize    = 48
xfirst   = -30
xinc     = 1
yfirst   = 72
yinc     = -1
EOF

# ============================================================
# 2. Build a fine mask for Po Valley
# ============================================================

cdo -f nc -expr,'mask=1' -sellonlatbox,${W_PO},${E_PO},${S_PO},${N_PO} "${INPUT}" "${MASK_FINE}"

# ============================================================
# 3. Build coarse mask and convert it back to native grid
# ============================================================

cdo remapbil,"${COARSE_GRID}" "${MASK_FINE}" "${MASK_COARSE}"
cdo remapnn,"${INPUT}" "${MASK_COARSE}" "${MASK_NATIVE}"

# Convert mask to boolean (1 = Po Valley, 0 = elsewhere)
cdo -setrtoc,0,0.5,0 -setrtoc,0.5,1,1 "${MASK_NATIVE}" "${MASK_NATIVE}.tmp"
mv "${MASK_NATIVE}.tmp" "${MASK_NATIVE}"

# ============================================================
# 4. Extract the fine-resolution Po Valley field
# ============================================================

cdo ifthen "${MASK_NATIVE}" "${INPUT}" "${FINE_IN_PO}"

# ============================================================
# 5. Build the coarse 1° world field
# ============================================================

cdo remapbil,"${COARSE_GRID}" "${INPUT}" "${COARSE_WORLD}"

# Bring coarse to native grid
cdo remapnn,"${INPUT}" "${COARSE_WORLD}" "${COARSE_ON_NATIVE}"

# ============================================================
# 6. Mask out the Po Valley from the coarse field
# ============================================================

cdo ifthenelse "${MASK_NATIVE}" -setmisstoc,0 "${COARSE_ON_NATIVE}" "${COARSE_ON_NATIVE}" "${COARSE_OUTSIDE}.tmp"
mv "${COARSE_OUTSIDE}.tmp" "${COARSE_OUTSIDE}"

# Set Po Valley area in coarse file to missing
cdo ifthenelse "${MASK_NATIVE}" -setmisstoc,nan "${COARSE_OUTSIDE}" -setmisstoc,nan "${COARSE_ON_NATIVE}" "${COARSE_OUTSIDE}.tmp"
mv "${COARSE_OUTSIDE}.tmp" "${COARSE_OUTSIDE}"

# ============================================================
# 7. Merge PO Valley high-res and coarse outside region
# ============================================================

cdo merge "${FINE_IN_PO}" "${COARSE_OUTSIDE}" "${OUTPUT}.tmp"

# Final sanity cleanup: keep finest values where both overlap
cdo -expr,'var=var1+var2' "${OUTPUT}.tmp" "${OUTPUT}"

echo "MOSAIC created → ${OUTPUT}"
echo "Temporary files in ${TMPDIR}"
