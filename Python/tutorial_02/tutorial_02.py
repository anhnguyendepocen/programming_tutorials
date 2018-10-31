""" Python Tutorial 02: Basic Data Wrangling

Follow along at: https://christophrenkl.github.io/programming_tutorials/

Author: Christoph Renkl (christoph.renkl@dal.ca)

This script provides you with an overview of 'data wrangling' with Python which
is a fancy term for accessing and modifying data. This overview is not
exhaustive by any means, but is intended to make you familiar with some basic
concepts of programming. If you spot any mistakes or issues, please report them
to christoph.renkl@dal.ca.
"""

#%% Indexing (Slicing)

# In the last tutorial, we introduced a few data types which can store multiple
# values, namely lists, tuples, and dictionaries. These data types are also
# also called containers or collections.

# Let's define a list:
lst = [5, 89.2, 'boat', 0, 9999., True, 'banana', 42, 3.14295, 'ten']

# Check if it is actually a list
print(type(lst))

# Sometimes you want to may want to access certain elements of a container and
# this is where indexing comes into play. An index is the position of a value
# in a container. It is important to note that Python's indexing is zero based
# which means that the index of the first item is 0.

# You can select the value at a certain position (index) of a container by
# by typing the index in brackets after the variable name:
lst[0]  # first element of variable lst
lst[6]  # 7th element of variable lst

# You can also select a sequence of indices - this is called slicing:
# In the brackets, write the first and last index of the desired sequence
# separated by a colon
lst[4:8]  # fifth to 8th element of variable lst

# Note that the last index is excluded! This can be a bit confusing.

# You can also count from the end of a sequence
lst[-1] # returns last element of variable lst

# If you only want every second item of a slice, add another colon for the
# increment, here two
lst[:8:2] # returns first to 8th element, but skips every other

# Use slicing to reverse a list
lst[::-1]

# The same syntax applies to tuples
tpl = ('Halifax', 'Montreal', 'Toronto', 'Vancouver')
tpl[1:]

# Just as a reminder, items of a dictionary are accesses by their key
dct = {'Apple'  : 'Fruit',
       'Carrot' : 'Vegetable',
       'Pear'   : 'Fruit',
       'Peach'  : 'Fruit',
       'Potato' : 'Vegetable',
       'Banana' : 'Fruit'}

print(dct['Carrot']) # print value of specific key
print(dct['Banana'])

#%% Installing Packages

# Before we look at some real data, we need a package which is not
# automatically installed with the Anaconda distribution of Python. However,
# we can use Anaconda's package manager conda to install new packages

# On Linux or Mac open a terminal and type
# conda install -c conda-forge cmocean

# On Windows open the Anaconda prompt from the start menu and type
# conda install -c conda-forge cmocean

#%% Indexing and Subsetting pandas DataFrames

# Another data type that was introduced in the first tutorial is a pandas
# DataFrame. The benefit of using pandas DataFrames is that you can access or
# subset them based on either traditional indexing or labels

# Before reading in some data, let's load all packages that we will need for
# the remainder of the tutorial
import pandas as pd
import matplotlib.pyplot as plt
import cmocean.cm as cmo

# Read data - these are from a glider mission along the Halifax line in 2015
df = pd.read_csv('data/raw/otn200_20151027_53_delayed.csv')

# print the first 10 rows
print(df.head(10))

# DataFrames are basically arrays with two dimensions: rows and columns.

# Columns are accessed like a dictionary by their column name
print(df['temperature'])

# Each row of a DataFrame has a label (index) which you can access specific
# rows with.# Print the labels of the DataFrame
print(df.index)

# By default, the labels are just a sequence starting with zero, but we can
# change that, e.g.
df.index = df.index + 5

# Check the result - note that only the label has changed
print(df.head(10))

# For accessing rows by their label, use .loc
print(df.loc[10]) # Note that this selects the row with the label 10 and not
                  # the 11th row which you may have expected
# Since in this case the labels are integers, we can use the same syntax as
# above to select sequence of rows
print(df.loc[7:15])
print(df.loc[:100:10])

# You can also provide a list of labels to select a number of individual rows
print(df.loc[[56, 8, 333, 1000, 13, 75]])

# You can combine .loc with the column names
print(df.loc[[11, 89, 250], 'temperature'])
print(df.loc[[11, 89, 250], ['lat', 'lon']])

# Note that it always keeps track of the indexes in the original DataFrame

# You can also access rows by their integer position using .iloc. Remember that
# Python is zero based
print(df.iloc[10]) # This selects the 11th row of the DataFrame

# The usual slicing works as well
print(df.iloc[7:15])
print(df.iloc[:100:10])

# And lists too
print(df.iloc[[56, 8, 333, 1000, 13, 75]])

# When you are using .iloc and only want to access a specific column, you have
# to specify it by its column number
print(df.iloc[7,  5]) # temperature is in the 6th column

#%% Working with Date/Time

# For time series, it is useful to set the time column as the index. We first
# have to tell Python which column has the date and time information and change
# the data type

# Let's have a look at the first item of the time column, and see what data
# type it is
print(df['time'].iloc[0])
print(type(df['time'].iloc[0]))

# It is a string which is formatted in a specific way that allows us to extract
# the individual parts of the date and time
df['time'] = pd.to_datetime(df['time'], format='%Y-%m-%dT%H:%M:%SZ')

# Check the results
print(df['time'].iloc[0])
print(type(df['time'].iloc[0]))

# Now that we successfully formatted our time column, we will use it to replace
# the (meaningless) integer labels
df = df.set_index('time')

print(df.head())

# We know that the glider was released outside Halifax and travelled to the
# shelf break and back. I know that it turned around around 3:30 in the morning
# on  November 8th, 2015. In order to subset the data from the outward leg, We
# can simply select all data until the day before
dfs = df.loc[:'2015-11-07']

#%% Advanced Plotting

# Note that we will use functions from the matplotlib package which we imported
# above.

# We have a very rich dataset at our fingertips with temporal and spatial
# information of multiple parameters. Before you start using it for science, it
# is good practice to have a look at your raw data and explore them.

# In the last tutorial we introduced the basic plotting functionalities. Now we
# want to be more explicit with the setup and design of our plots. This
# This requires a few more lines of code, but it gives us more flexibility.

# First, set up a figure of a certain size with one subplot
fig, ax = plt.subplots(nrows=1, ncols=1, figsize=(9.3, 7.5))

# We now have two variables which refer to the entire figure (fix) and the axis
# of the subplot (ax), respectively. Later we will see how we can use the same
# syntax to create one figure with multiple subplots (axes)

# Since we now have direct access to the axis, we can use this to plot the
# glider depth as a function of time - remember that time is in the index
ax.plot(df.index, df['depth'],
        color='grey',
        label='Whole Mission')

# On the same axis, we now plot the subset of the outward leg in blue
ax.plot(dfs.index, dfs['depth'],
        color='C0',
        label='Outward Leg')

# invert y-axis
ax.invert_yaxis()

# set a legend
ax.legend()

# set label and title
ax.set_ylabel('Depth [m]')
ax.set_title('otn200_20151027_53_delayed')

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# Let's create a new plot for zoom in on the subset of the outward leg. We know
# from the DataFrame that temperature, salinity, and density were measured
# simultaneously, so we will create one figure with three subplots (axes).

# Create a figure with three axes
fig, (ax1, ax2, ax3) = plt.subplots(nrows=3, ncols=1,
                                    figsize=(7.5, 9.3),
                                    sharex=True, sharey=True)

# First axis: temperature -----------------------------------------------------
sc = ax1.scatter(dfs.index, dfs['depth'],
                 c=dfs['temperature'],
                 s=3,
                 cmap=cmo.thermal)

# colorbar
fig.colorbar(sc, ax=ax1)

# title and y-label
ax1.set_title('Temperature [degC]')
ax1.set_ylabel('Depth [m]')

# Second axis: temperature ----------------------------------------------------
sc = ax2.scatter(dfs.index, dfs['depth'],
                 c=dfs['salinity'],
                 s=3,
                 cmap=cmo.haline)

# colorbar
fig.colorbar(sc, ax=ax2)

# title and y-label
ax2.set_title('Salinity [-]')
ax2.set_ylabel('Depth [m]')

# Third axis: temperature -----------------------------------------------------
sc = ax3.scatter(dfs.index, dfs['depth'],
                 c=dfs['density'],
                 s=3,
                 cmap=cmo.dense)

# colorbar
fig.colorbar(sc, ax=ax3)

# title and y-label
ax3.set_title('Density [kg/m3]')
ax3.set_ylabel('Depth [m]')

# We specified above that all subplots share the x- and y-axis. That means we
# only need to adjust the last one:

# invert y-axis
# ax3.invert_yaxis()

# set axis limits
ax3.set_xlim((dfs.iloc[0].name, dfs.iloc[-1].name))
ax3.set_ylim(210, 0)

# You may want to show this plot to your supervisor or send it to your friends.
# Therefore, we save the the figure as a PNG file
fig.savefig('figures/otn200_20151027_53_delayed_TSD_outward_leg.png')

#%% Saving Data

# As a final step, we save the subset of our original DataFrame. This allows us
# to reuse the data without going through all the whole subsetting steps again.
# I like to store pandas DataFrames as HDF files because it preserves all the
# labels. It is a binary data format which means that you won't be able to have
# a look at the data with a normal text editor (which isn't necessarily a bad
# thing).

# create an HDF store (note the *.h5 suffix)
store = pd.HDFStore('data/processed/otn200_20151027_53_delayed_outward_leg.h5')

# write DataFrame to store
store.put('df', dfs, data_columns=dfs.columns)

# close file
store.close()

# If you prefer to store your data into a *.csv file which you can read with a
# text editor or even Microsoft Excel
dfs.to_csv('data/processed/otn200_20151027_53_delayed_outward_leg.csv')

