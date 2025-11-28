#!/usr/bin/env bash
set -euo pipefail

# -----------------------------------------
# Usage:
#   ./download_era5.sh START END VARIABLE OUTFILE
#
# Example:
#   ./download_era5.sh 2022 2025 surface_pressure ps_2022-2025.grib
# -----------------------------------------

START=${1:? "START year required"}
END=${2:? "END year required"}
VAR=${3:? "Variable name required"}
OUTFILE=${4:? "Output file required"}

# Build year list: "2022","2023","2024","2025"
YEAR_LIST=""
for Y in $(seq ${START} ${END}); do
    if [[ -z "${YEAR_LIST}" ]]; then
        YEAR_LIST="\"${Y}\""
    else
        YEAR_LIST="${YEAR_LIST},\"${Y}\""
    fi
done

TMP_PY=$(mktemp --suffix=".py")

cat > "${TMP_PY}" <<EOF
import cdsapi

client = cdsapi.Client()

request = {
    "product_type": ["reanalysis"],
    "variable": ["${VAR}"],
    "year": [${YEAR_LIST}],
    "month": [
        "01","02","03","04","05","06",
        "07","08","09","10","11","12"
    ],
    "day": [
        "01","02","03","04","05","06",
        "07","08","09","10","11","12",
        "13","14","15","16","17","18",
        "19","20","21","22","23","24",
        "25","26","27","28","29","30","31"
    ],
    "time": ["00:00","06:00","12:00","18:00"],
    "data_format": "grib",
    "download_format": "unarchived",
    "area": [72, -30, 25, 45]
}

client.retrieve(
    "reanalysis-era5-single-levels",
    request
).download("${OUTFILE}")
EOF

# -----------------------------
# Run the python script
# -----------------------------
echo "Running: ${TMP_PY}"
python3 "${TMP_PY}"


# -----------------------------
# Optional cleanup
# -----------------------------
 rm -f "${TMP_PY}"

echo "Download complete: ${OUTFILE}"

