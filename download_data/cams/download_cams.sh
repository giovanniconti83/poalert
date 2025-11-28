#!/usr/bin/env bash
set -euo pipefail

# -------------------------------------------------------
# USAGE:
#   ./download_cams_forecast.sh START_DATE END_DATE VARIABLE OUTFILE
#
# VARIABLES:
#   pm10  → particulate_matter_10um
#   pm2p5 → particulate_matter_2p5um
# -------------------------------------------------------

# Check argument count
if [[ $# -ne 4 ]]; then
    echo "Error: wrong number of arguments."
    echo "Usage: ./download_cams_forecast.sh START_DATE END_DATE VARIABLE OUTFILE"
    exit 1
fi

START_DATE_RAW="$1"
END_DATE_RAW="$2"
VAR="$3"
OUTFILE="$4"

# Map variable names
case "${VAR}" in
    pm10)  CAMS_VAR="particulate_matter_10um" ;;
    pm2p5) CAMS_VAR="particulate_matter_2p5um" ;;
    *)
        echo "Invalid variable: ${VAR}"
        echo "Use: pm10 or pm2p5"
        exit 1
        ;;
esac

# CAMS availability window
CAMS_START="2022-11-23"
CAMS_END="2025-11-27"

# Clip user dates
START=$(printf "%s\n%s" "${START_DATE_RAW}" "${CAMS_START}" | sort | tail -n1)
END=$(printf "%s\n%s" "${END_DATE_RAW}" "${CAMS_END}" | sort | head -n1)

echo "Requested interval : ${START_DATE_RAW} → ${END_DATE_RAW}"
echo "Clipped to CAMS    : ${START} → ${END}"

TMP_PY=$(mktemp --suffix=".py")

cat > "${TMP_PY}" <<EOF
import cdsapi

client = cdsapi.Client()

dataset = "cams-europe-air-quality-forecasts"

request = {
    "variable": ["${CAMS_VAR}"],
    "model": ["ensemble"],
    "level": ["0"],
    "type": ["analysis"],
    "date": ["${START}/${END}"],
    "time": ["00:00", "06:00", "12:00", "18:00"],
    "leadtime_hour": ["0"],
    "data_format": "grib",
    "area": [46.5, 7, 44, 13]
}

client.retrieve(dataset, request).download("${OUTFILE}")
EOF

python3 "${TMP_PY}"

echo "Download complete → ${OUTFILE}"
