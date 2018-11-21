#!/usr/bin/env python3
# -*- coding: utf-8 -*-
""" Python Tutorial 05: 

Follow along at: https://christophrenkl.github.io/programming_tutorials/

Author: Christoph Renkl (christoph.renkl@dal.ca)

This is an example of a module for simple data analysis. If you spot any
mistakes or issues, please report them to christoph.renkl@dal.ca.
"""

#%% Import all packages which we will need
import cartopy.crs as ccrs
import cartopy.feature as cfeature
import cmocean.cm as cmo
import matplotlib.animation as anim
import matplotlib.pyplot as plt
from mpl_toolkits.axes_grid1 import make_axes_locatable
import numpy as np
import os
import pandas as pd
import xarray as xr


#%% Master script (function) to run data analysis
def main():

    # define and move to working directory
    wdir = '/home/chrenkl/Projects/programming_tutorials/Python/tutorial_05/'
    os.chdir(wdir)
    
    # directory with raw data
    rawdir = 'data/raw'# deployment ID
    
    # deployment ID
    ID = 'otn200_20151027_53_delayed'
    
    # A try-except block is similar to an if statement. In this case, we are
    # trying to read a data file. If the file does not exist, we download the
    # data first.
    try:
        df = pd.read_hdf('data/raw/{}.h5'.format(ID))
    except:
        # get data from glider mission
        df = get_glider_data(ID)
    
    # The data are from a mission along the Halifax line and contain an 
    # outbound and inbound part. Let's only focus on the former, so we find the
    # date and time of the maximum longitude and select all the data until
    # then.
    
    # determine return date
    ret_date = df['lon'].idxmax()
    
    # subset DataFrame
    df = df.loc[:ret_date]
    
    # We would like to compare the glider measurements with satellite
    # observations. OISST is a gridded dataset of sea surface temperature (SST)
    # which uses an optimal interpolation technique to create continous data in
    # space and time.
    
    # create file name
    sstfile = 'data/raw/oisst_{}_outward.nc'.format(ID)
    
    # try to open sstfile or download OISST data for the time period of the
    # glider mission.
    try:
        sst = xr.open_dataset(sstfile)['sst']
    except:
        sst = get_oisst(df.index, outfile=sstfile)

    lonmin = df['lon'].min() - 5. + 360.
    lonmax = df['lon'].max() + 5. + 360.
    latmin = df['lat'].min() - 5.
    latmax = df['lat'].max() + 5.
    
    sst = sst.sel(lon=slice(lonmin, lonmax), lat=slice(latmin, latmax))

    # Visualization
    data_crs = ccrs.PlateCarree()
    land50 = cfeature.NaturalEarthFeature('physical', 'land', '50m',
                                          linewidth=.5,
                                          edgecolor=[.4, .4, .4],
                                          facecolor=[.6, .6, .6])
    
    # set up figure
    fig = plt.figure(figsize=(8.5, 11.))
    
    # screate axis
    ax1 = fig.add_subplot(111, projection=ccrs.PlateCarree())
    ax1.set_extent([lonmin, lonmax, latmin, latmax], crs=ccrs.PlateCarree())
    
    divider = make_axes_locatable(ax1)
    ax2 = divider.append_axes('bottom', size='50%', pad=0.25,
                              axes_class=plt.Axes)
    
    frames = sst['time'].size
    
    def draw(frame):
        
        # get date
        date = sst['time'].isel(time=frame).values + np.timedelta64(1, 'D')       
            
        # plot SST as contours
        cs = ax1.contourf(sst['lon'], sst['lat'], sst.isel(time=frame), 255,
                          vmin=3.,
                          vmax=27.,
                          cmap=cmo.thermal,
                          transform=data_crs)
        
        # plot glider track
        track = ax1.plot(df.loc[df.index < date, 'lon'],
                         df.loc[df.index < date, 'lat'],
                         '-k',
                         linewidth=3)

        # add coastlines
        ax1.add_feature(land50)
        
        sc = ax2.scatter(df.loc[df.index < date].index,
                         df.loc[df.index < date, 'depth'],
                         c=df.loc[df.index < date, 'temperature'],
                         s=3,
                         vmin=3.,
                         vmax=27.,
                         cmap=cmo.thermal)
        
        return (cs, track, sc)
    
    def init():
        
        # set axis limits
        ax2.set_xlim(df.index[0], df.index[-1])
        ax2.set_ylim(210, 0)
        
        return draw(0)
    
    def animate(frame):
        return draw(frame)
    
    ani = anim.FuncAnimation(fig, animate, frames,
                              blit=False, init_func=init, repeat=True)
    
    outfile = 'animations/{}.mp4'.format(ID)
    
    # create output directory if it does not exist
    if not os.path.exists(os.path.dirname(outfile)):
        os.makedirs(os.path.dirname(outfile))
        
    ani.save(outfile, writer=anim.FFMpegWriter(fps=1))


#%%    
def get_oisst(dates, outfile='data/raw/oisst.nc'):
    '''Downloads OISST data for specific dates and saves them locally.
    
    Input:
    - dates: pandas.DatetimeIndex() with desired dates
    - (optional) outfile: filename of output file
    
    Output:
    - sst: xr.DataArray with SST data for desired dates
    '''
    
    # base URL
    base_url = 'http://www.ncei.noaa.gov/thredds/dodsC/OisstBase/NetCDF/AVHRR'
    
    # find unique days
    unique_dates = dates.normalize().unique()
    
    # empty list which will get filled with file names for unique dates
    files = []
    
    for dd in unique_dates:

        # get date components        
        year = dd.year
        month = dd.month
        day = dd.day
        
        # add filename to list
        files.append('{0}/{1}{2}/avhrr-only-v2.{1}{2:02d}{3:02d}.nc'.format(base_url, year, month, day))
    
    # read data files
    sst = xr.open_mfdataset(files)['sst']
    sst = sst.drop('zlev').squeeze()
        
    # create output directory if it does not exist
    if not os.path.exists(os.path.dirname(outfile)):
        os.makedirs(os.path.dirname(outfile))
        
    # save data as NetCDF file
    # sst.to_netcdf(outfile)
    
    return sst

#%% 
def get_glider_data(ID):
    '''
    Downloads data from OTN glider mission and saves them locally.
    
    Input:
    - ID: deployment ID of glider mission
    
    Output:
    - df: pandas.DataFrame() with glider data
    '''
    
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
    
    # The time column is a string which is formatted in a specific way that
    # allows us to extract the individual parts of the date and time
    df['time'] = pd.to_datetime(df['time'], format='%Y-%m-%dT%H:%M:%SZ')
       
    # Now that we successfully formatted our time column, we will use it to replace
    # the (meaningless) integer labels
    df = df.set_index('time')
    
    # name of output file
    outfile = os.path.join('data/raw/{}.h5'.format(ID))
    
    # create output directory if it does not exist
    if not os.path.exists(os.path.dirname(outfile)):
        os.makedirs(os.path.dirname(outfile))
        
    # save data in HDF5 store
    store = pd.HDFStore(outfile, 'w')
    store.put('df', df, data_columns=df.columns)
    store.close()
    
    return df


#%%
if __name__ == "__main__":
    main()