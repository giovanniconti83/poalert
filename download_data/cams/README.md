# 1. Load environment containing cdsapi
source activate cds_nlq


===================================
### CAMS PM10 / PM2.5 Download Script
===================================

# Usage:
./download_cams.sh START_YEAR END_YEAR VARIABLE OUTFILE

# Variables:
#   pm10   → particulate_matter_10um
#   pm2p5  → particulate_matter_2p5um

nohup ./download_cams.sh 2022-01-01 2025-12-31 pm10 /work/cmcc/gc02720/poalert/cams/pm10_2022-2025.grib > log_pm10.txt 2>&1 &

nohup ./download_cams.sh 2022-01-01 2025-12-31 pm2p5 /work/cmcc/gc02720/poalert/cams/pm25_2022-2025.grib > log_pm25.txt 2>&1 &




### Converting


nohup ./convert_all_grib_to_nc.sh /work/cmcc/gc02720/zambesi_data/grib /work/cmcc/gc02720/zambesi_data/era5_nc > convert.log 2>&1 &



### Split

./split_train_test.sh /work/cmcc/gc02720/zambesi_data/era5/tp_2010-2022.nc 2010 2020 2021 2022  /work/cmcc/gc02720/zambesi_data/zambesi_split tp
./split_train_test.sh /work/cmcc/gc02720/zambesi_data/era5/t2m_2010-2022.nc 2010 2020 2021 2022  /work/cmcc/gc02720/zambesi_data/zambesi_split t2m
./split_train_test.sh /work/cmcc/gc02720/zambesi_data/era5/sst_2010-2022.nc 2010 2020 2021 2022  /work/cmcc/gc02720/zambesi_data/zambesi_split sst
./split_train_test.sh /work/cmcc/gc02720/zambesi_data/era5/u10m_2010-2022.nc 2010 2020 2021 2022  /work/cmcc/gc02720/zambesi_data/zambesi_split u10m
./split_train_test.sh /work/cmcc/gc02720/zambesi_data/era5/v10m_2010-2022.nc 2010 2020 2021 2022  /work/cmcc/gc02720/zambesi_data/zambesi_split v10m
./split_train_test.sh /work/cmcc/gc02720/zambesi_data/era5/ps_2010-2022.nc 2010 2020 2021 2022  /work/cmcc/gc02720/zambesi_data/zambesi_split ps



