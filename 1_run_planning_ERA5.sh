#!/bin/bash
#SBATCH -C knl
#SBATCH -N 4
#SBATCH -q debug
#SBATCH -t 00:30:00
#SBATCH -A m1517
#SBATCH -J 1_run_planning_ERA5

# use symlinks to reorganize the data
if [[ ! -e CMIP6_ERA5_e5_oper_an_sfc ]]
then
    mkdir CMIP6_ERA5_e5_oper_an_sfc/
    for d in `ls --color=never  /global/cfs/cdirs/m3522/cmip6/ERA5/e5.oper.an.sfc`
    do
        f=/global/cfs/cdirs/m3522/cmip6/ERA5/e5.oper.an.sfc/${d}/e5.oper.an.sfc.128_137_tcwv.*.nc
        ln -s ${f} CMIP6_ERA5_e5_oper_an_sfc/
    done
fi

# bring a TECA install into your environment.
# change the following paths to point to your TECA install
module swap PrgEnv-intel PrgEnv-gnu
module use /global/cscratch1/sd/loring/teca_testing/deps/seasonal_reduction/modulefiles/
module load teca

# print the commands as they execute, and error out if any one command fails
set -e
set -x

# configure HDF5 file locking if on Cori (CFS)community file system
# This is not needed on Cori Lustre scratch file system
export HDF5_USE_FILE_LOCKING=FALSE

# run the probe to determine number size of the dataset
time srun -n 247 teca_metadata_probe \
    --input_regex ./CMIP6_ERA5_e5_oper_an_sfc/'.*\.nc$' \
    --x_axis_variable longitude --y_axis_variable latitude

# A total of 360840 steps available in 494 files. Using the gregorian calendar.
# Times are specified in units of hours since 1900-01-01 00:00:00. The available
# times range from 1979-1-1 0:0:0 (692496) to 2020-2-29 22:59:60 (1.05334e+06).
#
# Mesh dimension: 2D
# Mesh coordinates: longitude, latitude
#
# 5 data arrays available
#
#   Id   Name         Type         Dimensions                     Shape
# --------------------------------------------------------------------------------
#   1    TCWV         NC_FLOAT     [time, latitude, longitude]    [360840, 721, 1440]
#   2    latitude     NC_DOUBLE    [latitude]                     [721]
#   3    longitude    NC_DOUBLE    [longitude]                    [1440]
#   4    time         NC_INT       [time]                         [360840]
#   5    utc_date     NC_INT       [time]                         [360840]
