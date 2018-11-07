#!/usr/bin/env python3
# -*- coding: utf-8 -*-
""" Download Bedford Basin Monitoring Program data

This script downloads data of the most recent CDT cast of the Bedford Basin
Monitoring Program and stores a subset as a .csv file.

More information about Bedford Basin Monitoring Program:
http://www.bio.gc.ca/science/monitoring-monitorage/bbmp-pobb/bbmp-pobb-en.php
"""

# import modules
import os
import pandas as pd

def main():

    # define and move to working directory
    wdir = '/home/chrenkl/Projects/programming_tutorials/Python/tutorial_03/'
    os.chdir(wdir)
    
    # define directory for output data
    data_dir = os.path.join(wdir, 'data/raw')
    
    # create output directory if it doesn't exist
    if not os.path.isdir(data_dir):
        os.makedirs(data_dir)
    
    # On the FTP server, there is a *.csv file with all CTD casts. We read this
    # file and rearrange the data to save them in a NetCDF file which makes
    # further analysis easier.
    
    # server name and path to CSV files
    server = 'ftp.dfo-mpo.gc.ca'
    file = 'BIOWebMaster/BBMP/CSV/bbmp_aggregated_profiles.csv'
       
    # create full path to file
    fname = 'ftp://{0}/{1}'.format(server, file)
    
    # read file into pandas DataFrame, skip the first 10 rows with metadata
    df = pd.read_csv(fname,
                     usecols=[0, 6, 7, 13, 14, 15])
        
    # convert time_string column to datetime format
    df['time_string'] = pd.to_datetime(df['time_string'],
                                       format='%Y-%m-%d %H:%M:%S')
    
    # set time and pressure columns as index
    df = df.set_index(['time_string', 'pressure'])
    
    # there are duplicate indices, we only keep the first occurence
    df = df.loc[~df.index.duplicated(keep='first')]
    
    # convert DataFrame to xarray Dataset
    ds = df.to_xarray().rename({'time_string': 'time'})
    
    # only keep measurements every half meter
    ds = ds.where((ds.pressure % .5 == 0.) &
                  (ds.pressure <= 70.), drop=True)
    
    # name of output file
    outfile = os.path.join(data_dir, 'bedford_basin_monitoring_program.nc')
    
    # write Dataset tp output file
    ds.to_netcdf(outfile)
    
    # close Dataset
    ds.close()
    

if __name__ == "__main__":
    main()
