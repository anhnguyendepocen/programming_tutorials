""" Python Tutorial 03: Numerical Python, and Conditions

Follow along at: https://christophrenkl.github.io/programming_tutorials/

Author: Christoph Renkl (christoph.renkl@dal.ca)

This script provides you with an introduction tp numerical Python using the
widely known package 'NumPy'. We will also introduce loops and conditions which
make your data wrangling easier. If you spot any mistakes or issues, please
report them to christoph.renkl@dal.ca.
"""

#%% Numerical Python using NumPy

# So far, we have learned about high-level number data types and containers.
# NumPy offers you an extension for multidimensional arrays and it also comes
# with a lot of useful functions which are written in a way that you can
# apply operations to each element in the array very efficiently.

# Import the NumPy package
import numpy as np

# Create a 1D array a.k.a. vector. We do this by providing a list to the
# np.array() function
vec = np.array([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])

# Let's do some math
vec + 3   # add 3 to each element in array
vec - 7   # subtract 7 from each element in array
vec * 10  # multiply each element by 10
vec / 10  # divide each element by 10
vec ** 2  # raise each element to the power of 2

# Python does not know about square roots - in order to compute the square root
# of a particular number, you could raise it to the power of 1/2 which is
# mathematically the same. Note that you hve to set parantheses around the
# exponent to compute it before the exponentiation.
16 ** (1/2)

# NumPy has a function for this computation
np.sqrt(16)

# This function also works for arrays
np.sqrt(vec)  # calculate square root of each element

# We can also create arrays with higher dimensions providing a list with one
# list per dimension
arr = np.array([[1, 2, 3], [4, 5, 6]]) # 2D array (matrix), each list becomes a
                                       # row in the array
                                       
# To get information about arrays we can use the attributes ndim and shape
arr.ndim
arr.shape

# There are more ways of creating arrays
arr1 = np.arange(1, 11, 1)   # start, end (exclusive), increment
arr2 = np.linspace(0, 1, 6) # start, end, number of elements
arr3 = np.ones((3, 3))       # 2D array with each element equal to 1
arr4 = np.zeros((3, 3, 2))   # 3D array with each element equal to 0

# Indexing works just like before, remember Python is zero based
arr1[3]
arr2[-3:]
arr3[1, :1]
arr4[..., 1]

#%% Conditions and if-Statements

# With conditions you can let Python answer simple yes/no questions. Generally,
# you compare two objects with an operator. The basic ones are
#
#   ==   equal to
#   !=   not equal to
#   >=   greater or equal to
#   <=   less than or equal to
#   >    greate than
#   <    less than
#   in   within/part of
#
# A comparison always returns 'True' or 'False'
7 == 5     # is 7 equal to 5
arr1 != 8  # is arr1 not equal to 8
arr1 >= 5  # is arr1 greater or equal to 5
arr1 > 5   # is arr1 greater than 5
arr1 <= 5  # is arr1 smaller or equal to 5
arr1 < 5   # is arr1 smaller than 5
17 in arr1 # is 17 within/part of arr1

# You can use the answer for logical accessing of parts of arrays
arr1[arr1 != 8] # return all elements of arr1 that are not equal to 8
arr1[arr1 > 5] # return all elements of arr1 that are larger than 5

# Conditions are very useful when you want to execute certain parts of your
# script only when a certain criterion is met. This is done through
# if statements:

# Define a short vector
vec = np.array([23, 566, 8, 4646, 78, 51664, np.nan, 763, 6, 0, 123, 42, 9999])

# define a value of interest
val = 42

# Set up the if-statement. You can read is as: " if [val] is an element of
# [vec], then print the message to the terminal
if val in vec:
    print('Hooray, {} is in the vector!'.format(val))

# Note that the indentation of four spaces after the is crucial! The condition
# you want to check is written after the word 'if'. Everything that is indented
# will only be executed if the condition is met.
    
val = 17
    
# Now extend the if-statement for the case that the condition is not met:
if val in vec:
    print('Hooray, {} is in the vector!'.format(val))
    
else:       
    print('Sorry, {} is NOT in the vector!'.format(val))

# Play around with the value of 'val' and see how the message changes.
    
# We can also allow for a hierachy of conditions. If the first condition is not
# met, try another condition and use the else-statement as a last resort.
    
# First calculate the mean of our vector - we use the NumPy function for this
vec_mean = np.nanmean(vec)

# 
if val in vec:
    print('Hooray, {} is in the vector!'.format(val))
    
elif val < vec_mean:   
    print('Too bad, {} is not in the vector, but it is smaller'.format(val),
          'than the mean value of the vector!')
    
else:       
    print('Sorry, {} is NOT in the vector!'.format(val))

#%% Arrays and Conditions in Data Analysis

# We will now apply some of the concepts we have covered so far to real data.

# Import all packages which we will need for the remainder this tutorial.
import cmocean.cm as cmo
import os
import matplotlib.pyplot as plt
import xarray as xr # This is a great package which applies most of pandas
                    # functionalities to multidimensional arrays. It is also a
                    # great tool for working with NetCDF data files.
                    
# make sure you are in the right working directory
os.chdir('/home/chrenkl/Projects/programming_tutorials/Python/tutorial_03/')

# Read data - these are all CTD casts from the Bedford Basin Monitoring Program
ds = xr.open_dataset('data/raw/bedford_basin_monitoring_program.nc')

# The variable 'ds' holds a xarray Dataset. Let's have a look at the content
print(ds.info)

# As you can see, it has four data variables which are 2D arrays sharing the
# same coordinates time and pressure. Under the hood, the data variables are
# NumPy arrays and you can use them in the same way. The benefit of the xarray
# Dataset is that it assigns names and labels to the rows and columns of the
# arrays which makes accessing certain values much easier and more explicit.

# It is good practice to keep your code flexible and less repetitive. The goal
# is to plot one of the data variables with appropriate labels showing the
# units of the variables. Wouldn't it be nice if we could write the code in a
# way that it knows which unit and color scheme to use just based on the name
# of the variable?

# Define a variable with the name of the temperature data in the xarray Dataset
vname = 'temperature'

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
    
else:
    units = ''
    name = vname.capitalize()
    cmap = 'viridis'
    vmin = ds[vname].min()
    vmax = ds[vname].max()
    
# Create title string
title = 'Bedford Basin Monitoring Program - {}'.format(name)

# Set up a figure of a certain size with one subplot
fig, ax = plt.subplots(nrows=1, ncols=1, figsize=(11., 4.5))

# Plot the variable as a function of time and pressure
pcm = ax.pcolormesh(ds['time'], ds['pressure'],
                    ds[vname].transpose(),
                    vmin=vmin,
                    vmax=vmax,
                    cmap=cmap)

# invert y-axis
ax.invert_yaxis()

# colorbar
cb = fig.colorbar(pcm, ax=ax)

# The colorbar has its own axis, put the units in the title
cb.ax.set_title(units)

# set label and title
ax.set_ylabel('Depth [m]')
ax.set_title(title)

# make sure the plot takes up all space on the figure
fig.tight_layout()

# We want to save the plot in a dedicated directory. We can use an if-statement
# to see if that directory already exists and if not, create it

# define the name of the subfolder for figures
figdir = 'figures'

# use the isdir() function from os package
if not os.path.isdir(figdir):
    os.makedirs(figdir)

# save figure
fig.savefig('figures/bbmp_{}.pdf'.format(vname))

# Play around by changing 'vname' and see how the plot changes.

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# All Variables show a seasonal cycle, but clearly, there is some interannual
# variability.

# With xarray, it is very easy to compute a monthly climatology:
clim = ds.groupby('time.month').mean(dim='time')

# We can subtract the climatology from our original data to get anomalies
anom = ds.groupby('time.month') - clim

# Define a variable with the year of interest
year = '2018'

# It is straightforward to create a subset with anomalies for this year
dsyear = anom.sel(time=year)

# redefine vmin and vmax
vmax = abs(anom[vname]).max()
vmin = -vmax

# We can now use the almost the same code as above to create a time series of
# anomalies: 

# Set up a figure of a certain size with one subplot
fig, ax = plt.subplots(nrows=1, ncols=1, figsize=(11., 4.5))

# Plot the variable as a function of time and pressure
pcm = ax.pcolormesh(dsyear['time'], dsyear['pressure'],
                    dsyear[vname].transpose(),
                    vmin=vmin,
                    vmax=vmax,
                    cmap=cmo.balance)

# invert y-axis
ax.invert_yaxis()

# colorbar
cb = fig.colorbar(pcm, ax=ax)

# The colorbar has its own axis, put the units in the title
cb.ax.set_title(units)

# set label and title
ax.set_ylabel('Depth [m]')
ax.set_title(title + ' Anomalies')

# make sure the plot takes up all space on the figure
fig.tight_layout()

# save figure
fig.savefig('figures/bbmp_{}_anomalies.pdf'.format(vname))

# close Dataset
ds.close()

