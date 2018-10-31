#!/usr/bin/env python3
# -*- coding: utf-8 -*-
""" Download Ocean Tracking Network (OTN) glider data

This script downloads data of a glider mission and store it as a .csv file.
"""

import os
import pandas as pd

def main():

    # define and move to working directory
    wdir = '/home/chrenkl/Projects/programming_tutorials/Python/tutorial_02/'
    os.chdir(wdir)
    
    # define directory for output data
    data_dir = os.path.join(wdir, 'data/raw')
    
    # create output directory if it doesn't exist
    if not os.path.isdir(data_dir):
        os.makedirs(data_dir)

    # deployment ID
    ID = 'otn200_20151027_53_delayed'
    
    # base URL of ERRDAP server
    base_url = 'http://belafonte.ocean.dal.ca:8080/erddap/tabledap'

    # construct full URL
    url = '{}/{}.csvp?time%2Cdepth%2Clatitude%2Clongitude%2Cconductivity%2Ctemperature%2Csalinity%2Cdensity%2Cpressure%2Cprofile_id'.format(base_url, ID)

    # read *.csv file from ERRDAP server 
    df = pd.read_csv(url,
                     header=0,
                     names=['time', 'depth', 'lat', 'lon', 'conductivity',
                            'temperature', 'salinity', 'density', 'pressure',
                            'profile_id'])
    
    # only retain complete rows
    df = df.dropna()
    
    # name of output file
    outfile = os.path.join(data_dir, '{}.csv'.format(ID))
    
    # write output file
    df.to_csv(outfile, index=False)


if __name__ == "__main__":
    main()
