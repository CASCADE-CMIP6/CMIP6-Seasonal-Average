#!/bin/bash

# use symlinks to reorganize the data such that all the files for a single
# variable are colocated in a single directory
if [[ ! -e CMIP6_ERA5_e5_oper_an_sfc ]]
then
    mkdir CMIP6_ERA5_e5_oper_an_sfc/
    for d in `ls --color=never  /global/cfs/cdirs/m3522/cmip6/ERA5/e5.oper.an.sfc`
    do
        f=/global/cfs/cdirs/m3522/cmip6/ERA5/e5.oper.an.sfc/${d}/e5.oper.an.sfc.128_137_tcwv.*.nc
        ln -s ${f} CMIP6_ERA5_e5_oper_an_sfc/
    done
fi
