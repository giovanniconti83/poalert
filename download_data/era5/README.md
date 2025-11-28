# ===============================================
### ERA5 Download Instructions
# ===============================================

# 1. Load environment containing cdsapi
source activate cds_nlq

# 2. Usage
./download_era5.sh START_YEAR END_YEAR VARIABLE OUTFILE.grib

# 3. Notes
# - Automatically expands START–END into correct "year" list
# - Downloads at 00, 06, 12, 18 UTC
# - Domain: Europe + partial Atlantic [72, -30, 25, 45]
# - Format: GRIB, unarchived

# 4. Examples (2022–2025)
nohup ./download_era5.sh 2022 2025 surface_pressure \
/work/cmcc/gc02720/poalert/era5/ps_2022-2025.grib > log_ps.txt 2>&1 &

nohup ./download_era5.sh 2022 2025 total_precipitation \
/work/cmcc/gc02720/poalert/era5/tp_2022-2025.grib > log_tp.txt 2>&1 &

nohup ./download_era5.sh 2022 2025 2m_temperature \
/work/cmcc/gc02720/poalert/era5/t2m_2022-2025.grib > log_t2m.txt 2>&1 &

nohup ./download_era5.sh 2022 2025 10m_u_component_of_wind \
/work/cmcc/gc02720/poalert/era5/u10_2022-2025.grib > log_u10.txt 2>&1 &

nohup ./download_era5.sh 2022 2025 10m_v_component_of_wind \
/work/cmcc/gc02720/poalert/era5/v10_2022-2025.grib > log_v10.txt 2>&1 &

nohup ./download_era5.sh 2022 2025 volumetric_soil_water_layer_1 \
/work/cmcc/gc02720/poalert/era5/swvl1_2022-2025.grib > log_swvl1.txt 2>&1 &

nohup ./download_era5.sh 2022 2025 evaporation \
/work/cmcc/gc02720/poalert/era5/evap_2022-2025.grib > log_evap.txt 2>&1 &

nohup ./download_era5.sh 2022 2025 surface_runoff \
/work/cmcc/gc02720/poalert/era5/sr_2022-2025.grib > log_sr.txt 2>&1 &

nohup ./download_era5.sh 2022 2025 sub_surface_runoff \
/work/cmcc/gc02720/poalert/era5/ssr_2022-2025.grib > log_ssr.txt 2>&1 &

nohup ./download_era5.sh 2022 2025 sea_surface_temperature \
/work/cmcc/gc02720/poalert/era5/sst_2022-2025.grib > log_sst.txt 2>&1 &




===================================
### CAMS PM10 / PM2.5 Download Script
===================================

# Usage:
./download_cams.sh START_YEAR END_YEAR VARIABLE OUTFILE

# Variables:
#   pm10   → particulate_matter_10um
#   pm2p5  → particulate_matter_2p5um

# Example: Download PM10 from 2022 to 2025
nohup ./download_cams.sh 2022 2025 pm10 \
/work/cmcc/gc02720/poalert/cams/pm10_2022-2025.nc > log_pm10.txt 2>&1 &

# Example: Download PM2.5
nohup ./download_cams.sh 2022 2025 pm2p5 \
/work/cmcc/gc02720/poalert/cams/pm25_2022-2025.nc > log_pm25.txt 2>&1 &





### Converting


nohup ./convert_all_grib_to_nc.sh /work/cmcc/gc02720/zambesi_data/grib /work/cmcc/gc02720/zambesi_data/era5_nc > convert.log 2>&1 &



### Split

./split_train_test.sh /work/cmcc/gc02720/zambesi_data/era5/tp_2010-2022.nc 2010 2020 2021 2022  /work/cmcc/gc02720/zambesi_data/zambesi_split tp
./split_train_test.sh /work/cmcc/gc02720/zambesi_data/era5/t2m_2010-2022.nc 2010 2020 2021 2022  /work/cmcc/gc02720/zambesi_data/zambesi_split t2m
./split_train_test.sh /work/cmcc/gc02720/zambesi_data/era5/sst_2010-2022.nc 2010 2020 2021 2022  /work/cmcc/gc02720/zambesi_data/zambesi_split sst
./split_train_test.sh /work/cmcc/gc02720/zambesi_data/era5/u10m_2010-2022.nc 2010 2020 2021 2022  /work/cmcc/gc02720/zambesi_data/zambesi_split u10m
./split_train_test.sh /work/cmcc/gc02720/zambesi_data/era5/v10m_2010-2022.nc 2010 2020 2021 2022  /work/cmcc/gc02720/zambesi_data/zambesi_split v10m
./split_train_test.sh /work/cmcc/gc02720/zambesi_data/era5/ps_2010-2022.nc 2010 2020 2021 2022  /work/cmcc/gc02720/zambesi_data/zambesi_split ps



