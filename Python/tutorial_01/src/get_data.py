#!/usr/bin/env python3
# -*- coding: utf-8 -*-
""" Download Bedford Basin Monitoring Program data

This script downloads data of the most recent CDT cast of the Bedford Basin
Monitoring Program and stores a subset as a .csv file.

More information about Bedford Basin Monitoring Program:
http://www.bio.gc.ca/science/monitoring-monitorage/bbmp-pobb/bbmp-pobb-en.php
"""

# import modules
from ftplib import FTP
import os
import pandas as pd

def main():

    # define and move to working directory
    wdir = '/home/chrenkl/Projects/programming_tutorials/Python/tutorial_01/'
    os.chdir(wdir)
    
    # define directory for output data
    data_dir = os.path.join(wdir, 'data')
    
    # create output directory if it doesn't exist
    if not os.path.isdir(data_dir):
        os.makedirs(data_dir)
    
    # The idea is to download the most recent CTD cast. On the FTP server, the
    # datea are stored by year. 
    
    # determine the current year
    year = pd.to_datetime('now').year
    
    # server name and path to CSV files
    server = 'ftp.dfo-mpo.gc.ca'
    path = 'BIOWebMaster/BBMP/CSV/{}'.format(year)
    
    # connect to DFO FTP server
    ftp = FTP(server)
    ftp.login()
    
    # move do data directory with CSV files
    ftp.cwd(path)
    
    # ftp.nlst() returns a list of all files in remote directory - choose the
    # last one (index [-1])
    file = ftp.nlst()[-1]
    
    # close connection to FTP server
    ftp.close()
    
    # create full path to file
    fname = 'ftp://{0}/{1}/{2}'.format(server, path, file)
    
    # read file into pandas DataFrame, skip the first 10 rows with metadata
    df = pd.read_csv(fname,
                     skiprows=10)
    
    # define columns to write to output file
    outvars = ['scan', 'pressure', 'temperature', 'salinity', 'sigmaTheta']
    
    # name of output file - get the cast ID from the file name and parse it
    cast_id = os.path.splitext(os.path.basename(fname))[0]
    outfile = os.path.join(data_dir, '{}_subset.csv'.format(cast_id))
    
    # write subset of DataFrame to output file
    df[outvars].to_csv(outfile, index=False)
    

if __name__ == "__main__":
    main()
