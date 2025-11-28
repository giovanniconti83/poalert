#!/usr/bin/env bash
set -euo pipefail

# USAGE:
#   ./convert_all_grib_to_nc.sh INPUT_DIR OUTPUT_DIR

INPUT_DIR=${1:?Missing input directory}
OUTPUT_DIR=${2:?Missing output directory}

module load intel-2021.6.0/eccodes/2.30.2-rxqus

mkdir -p "$OUTPUT_DIR"

echo "Converting all *.grib and *.grib2 files from:"
echo "  $INPUT_DIR"
echo "to NetCDF:"
echo "  $OUTPUT_DIR"
echo

# Loop over all GRIB files
for f in "$INPUT_DIR"/*.grib "$INPUT_DIR"/*.grb "$INPUT_DIR"/*.grib2 "$INPUT_DIR"/*.grb2
do
    # skip if file pattern does not match anything
    [ -e "$f" ] || continue

    base=$(basename "$f")
    name="${base%.*}"
    outfile="$OUTPUT_DIR/${name}.nc"

    echo "→ Converting: $f"
    grib_to_netcdf -k 4 -o "$outfile" "$f"
done

echo
echo "✓ All conversions completed."
