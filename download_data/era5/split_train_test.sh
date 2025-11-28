#!/usr/bin/env bash
set -euo pipefail

# =============================================================
# USAGE:
#   ./split_train_test.sh INPUT.nc TRAIN_START TRAIN_END TEST_START TEST_END OUTDIR
#
# EXAMPLE:
#   ./split_train_test.sh tp.nc 2010 2020 2021 2022 /path/out
# =============================================================

INPUT=${1:?Missing input NetCDF}
TRAIN_START=${2:?Missing training start year}
TRAIN_END=${3:?Missing training end year}
TEST_START=${4:?Missing test start year}
TEST_END=${5:?Missing test end year}
OUTDIR=${6:?Missing output directory}

TRAIN_DIR="${OUTDIR}/training"
TEST_DIR="${OUTDIR}/testing"

mkdir -p "$TRAIN_DIR" "$TEST_DIR"

echo "Splitting file:"
echo "  $INPUT"
echo "Training years: $TRAIN_START – $TRAIN_END"
echo "Testing years:  $TEST_START – $TEST_END"
echo
echo "Output directories:"
echo "  $TRAIN_DIR"
echo "  $TEST_DIR"
echo

module load intel-2021.6.0/cdo-threadsafe/2.1.1-lyjsw

# ----------------------------------------------
# TRAINING SUBSET
# ----------------------------------------------
TRAIN_OUT="${TRAIN_DIR}/$(basename ${INPUT%.*})_${TRAIN_START}-${TRAIN_END}.nc"

cdo seldate,${TRAIN_START}-01-01,${TRAIN_END}-12-31 \
    "$INPUT" "$TRAIN_OUT"

echo "✓ Training file created:"
echo "  $TRAIN_OUT"

# ----------------------------------------------
# TESTING SUBSET
# ----------------------------------------------
TEST_OUT="${TEST_DIR}/$(basename ${INPUT%.*})_${TEST_START}-${TEST_END}.nc"

cdo seldate,${TEST_START}-01-01,${TEST_END}-12-31 \
    "$INPUT" "$TEST_OUT"

echo "✓ Testing file created:"
echo "  $TEST_OUT"

echo
echo "✔ DONE."
