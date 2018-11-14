#!/usr/bin/env python3
# -*- coding: utf-8 -*-
""" Analysis of Bedford Basin Monitoring Program Data

Follow along at: https://christophrenkl.github.io/programming_tutorials/

Author: Christoph Renkl (christoph.renkl@dal.ca)

This is an example of a module for simple data analysis. If you spot any
mistakes or issues, please report them to christoph.renkl@dal.ca.
"""

#%% Import all packages which we will need
import cmocean.cm as cmo
import matplotlib.pyplot as plt
import numpy as np
import os
import pandas as pd
import xarray as xr

#%% Master script (function) to run data analysis
def main():

    # define and move to working directory
    wdir = '/home/chrenkl/Projects/programming_tutorials/Python/tutorial_04/'
    os.chdir(wdir)
    
    # directory with raw data
    rawdir = 'data/raw'
    
    # name of data file
    fname = 'bedford_basin_monitoring_program.nc'
    
    # check if data file already exists. If not download the data.
    if os.path.isfile(os.path.join(rawdir, fname)):
        
        # open existing data file as xarray.Dataset()
        ds =  xr.open_dataset(os.path.join(rawdir, fname))
        
    else:
        
        # download data, save file, and return xarray.Dataset()
        ds = download_bbmp_data(fname)

    # PLOTTING ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        
    # define the name of the subfolder for figures
    figdir = 'figures'
    
    # use the isdir() function from os package
    if not os.path.isdir(figdir):
        os.makedirs(figdir)
    
    # The idea is to plot a Hovmoeller diagram (variable as function of depth
    # and time) for all data variables in ds.
    
    # get names of all data variables
    dvars = list(ds.data_vars)
    
    # Create a figure with as many axes as variables in ds
    fig, axs = plt.subplots(nrows=len(dvars), ncols=1,
                            figsize=(7.5, 9.3),
                            sharex=True, sharey=True)
    
    # plot Hovmoeller diagrams
    for ii, vname in enumerate(dvars):
        pcm = plot_hovmoeller(ds, vname, axs[ii])
    
        # colorbar
        fig.colorbar(pcm, ax=axs[ii])

    # invert y-axes
    axs[ii].invert_yaxis()


    # make sure the plot takes up all space on the figure
    fig.tight_layout()
    
    # save figure
    fig.savefig('figures/bbmp_hovmeoller_diagrams.png')
    
    return


#%% 
def plot_hovmoeller(ds, vname, ax):
    '''
    Plot a Hovmoeller diagram (variable as function of depth and time)
    
    Input:
    - ds: xarray.Dataset with data
    - vname: name of variable to plot
    - ax: axis handle of figure
    
    Output:
    - pcm: handle to pcolormesh plot
    '''

    # Create an if-statement
    if vname == 'temperature':
        units = r'[$^\circ$C]'
        name = 'Temperature'
        cmap = cmo.thermal
        vmin = -2.
        vmax = 20.
        
    elif vname == 'salinity':
        units = '[-]'
        name = 'Salinity'
        cmap = cmo.haline
        vmin = 28.
        vmax = 32.
    
    elif vname == 'sigmaTheta':
        units = r'[kg/m$^3$]'
        name = r'Potential Density $\sigma_{{\theta}}$'
        cmap = cmo.dense
        vmin = 21.
        vmax = 25.5
    
    elif vname == 'oxygen':
        units = '[ml/l]'
        name = 'Oxygen'
        cmap = cmo.oxy
        vmin = ds[vname].min()
        vmax = ds[vname].max()
        
    else:
        units = ''
        name = vname.capitalize()
        cmap = 'viridis'
        vmin = ds[vname].min()
        vmax = ds[vname].max()
        
    # Create title string
    title = 'Hovmoeller Diagram - {0} {1}'.format(name, units)

    # Plot the variable as a function of time and pressure
    pcm = ax.pcolormesh(ds['time'], ds['pressure'],
                        ds[vname].transpose(),
                        vmin=vmin,
                        vmax=vmax,
                        cmap=cmap)
    
    # set label and title
    ax.set_ylabel('Pressure [dbar]')
    ax.set_title(title)
    
    return pcm


#%% 
def download_bbmp_data(outfile):
    '''
    Downloads Bedford Basin Monitoring Program data from the FTP server at
    Bedford Institute for Oceanography and saves it as NetCDF file.
    
    Input:
    - outfile: name of output data file
    
    Output:
    - ds: xarray.Dataset() with data
    '''
    
    # define directory for output data
    outdir = 'data/raw'
    
    # create output directory if it doesn't exist
    if not os.path.isdir(outdir):
        os.makedirs(outdir)
    
    # On the FTP server, there is a *.csv file with all CTD casts. We read this
    # file and rearrange the data to save them in a NetCDF file which makes
    # further analysis easier.
    
    # server name and path to CSV files
    server = 'ftp.dfo-mpo.gc.ca'
    file = 'BIOWebMaster/BBMP/CSV/bbmp_aggregated_profiles.csv'
       
    # create full path to file
    fname = 'ftp://{0}/{1}'.format(server, file)
    
    # read file into pandas DataFrame, only use certain columns
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
    outfile = os.path.join(outdir, outfile)
    
    # write Dataset tp output file
    ds.to_netcdf(outfile)
        
    return ds

#%%
if __name__ == "__main__":
    main()