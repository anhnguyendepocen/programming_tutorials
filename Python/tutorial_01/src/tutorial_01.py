""" Python Tutorial 01: Intro to Python

Follow along at: https://christophrenkl.github.io/programming_tutorials/

Author: Christoph Renkl (christoph.renkl@dal.ca)

This script provides you with an overview of the basic capabilities of Python
and is the first of a series of tutorials. If you spot any mistakes or issues,
please report them to christoph.renkl@dal.ca.
"""

#%% This is a cell [note that this only works in an IPython]

"""
Python, IPyton, and Spyder
-------------------------- 

- Python is a programming language
- IPython (Interactive Python) is a fancy interface
- Spyder is an Integrated Development Environment (IDE) for Python

Please note: This tutorial assumes you are using Spyder in the default setup.

1. All the text you are reading right now is a Python script (note the file
   suffix *.py) which is written in the editor. It's actually just a text file,
   which contains code that can be read by Python and translated to a command
   sent to your computer.
2. The bottom right pane is an IPython console. There you can directly type a
   command to tell Python to do stuff for you. You have to press the enter key
   to send off the command.
3. In the top right pane you have three tabs for your Variable explorer,
   File explorer and help.
   
Here are some useful shortcut keys:
- Press F5 to run the entire script
- Press F9 to run selection or line
- Press Ctrl + 1 to comment / uncomment
- Go to front of function and then press Ctrl + I to see documentation of the
  function
- Run %reset -f to clean workspace
- Run %clear to clean your IPython console
- Ctrl + Left click on object to see source code 
- Ctrl + Enter executes the current cell.
- Shift + Enter executes the current cell and advances the cursor to next one
"""
#%% Simple Operations:

# <- this hashtag symbol is a comment. Python ignores everything to the right
#    of it. Make use of them to leave yourself some notes in your code.

# You can use Python as a calculator. Type or copy the following lines into the
# console and pres the enter key. (HINT: you can also move the cursor into the
# line and press F9)

# Basic operators
2 + 2  # = 4, addition
5 - 3  # = 2, subtraction
3 * 4  # = 12, multiplication
7 / 2  # = 3.5, division
7 // 2 # = 3, division (floor)
7 % 2  # = 1, modulo
2 ** 8 # = 256, exponentiation

# Variables:
# use the equals sign to assign a variable. Note that these variables now
# appear in the Variable explorer
x = 12

# Let's do some math with the variables:
15 - x # = 3

# You can store the result of that calculation in a new variable
y = 15 - x # The variable y has now the value of 3 and can be used for further 
           # calculations

# Multiply the variables x and y  
z = x * y  # = 12 * 3 = 36

# If you want to see the result of this calculation, use the print() function
print(z)

# We will learn more about functions and how to use them soon.
#%% Data types

# Variables don't have to be numbers
txt = 'Hello World' # txt is of data type string (str)

# There are many more data types. Here are a few common ones:
a = 5       # integer (int)
b = 3.14195 # float
c = 'cat'   # string
d = True    # logical, boolean (bool)

# You can check the data type of any variable/object using the function type()
type(c)

# The variables above are single value data types which can be stored or
# organized in many other data types: 

# List - sequence of multiple values
lst1 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
type(lst1)

# Lists don't have to be just numbers, you can even mix data types
lst2 = ['cow','pig','horse','tugboat', 'pumpkin', 'hamster', 'onion', 'bean']
lst3 = [1, 2.3, c, False]

# You can add (concatenate) two lists
lst1 + lst2

# Multiplying a list with an integer creates copys of the list and concatenates
# them
lst1 * 3

# Lists are what's called "mutable" which basically means that you can add,
# remove, or change their elements. Next week, we will learn how to access and
# modify individual items in a list.

# Tuple, a "read-only" list which become important for returning values from
# functions
tpl1 = (1, 2, 3)
tpl2 = ('Halifax', 'Montreal', 'Toronto', 'Vancouver')

# Dictionary - pairs of keys and values
dct = {'Apple'  : 'Fruit',
       'Carrot' : 'Vegetable',
       'Pear'   : 'Fruit',
       'Peach'  : 'Fruit',
       'Potato' : 'Vegetable',
       'Banana' : 'Fruit'}

print(dct['Carrot']) # print value of specific key
print(dct['Banana'])
print(dct.keys())   # print all keys in dictionary

#%% Packages

# Python heavily relies on the concept of 'modular programming' which is just a
# fancy term for dividing the entire code base into smaller chunks called
# modules or packages. They are basically collections of functions and later in
# the tutorials, we will learn how to write our own modules.
# An advantage of modular programming is that it makes it easier to maintain
# and, more importantly, reuse the code.

# Pure Python only has a limited set of modules. However, due the beauty of
# being an open-source programming language, many people have dedicated their
# (spare) time and developed modules and packages with sophisticated
# functionalities and provide them to all Python users.
#
# If you installed Python through the Anaconda distribution many packages are
# already pre-installed, but you have to import (load) them every time you want
# to use in order to make them available for your script.

# There are different ways of importing a package. Typically this is done at
# the beginning of each script:

# Load the full os package which is helpful for path and filename operations.
import os

# Load full pandas package which is an excellent tool for time series analysis.
# We assign an abbreviation to it which makes it easier to use it's functions:
import pandas as pd

# only load the read_csv() function from pandas package
from pandas import read_csv

# Sometime you will see the following import statement:
# from pandas import *
# which means that you import all functions from a package. However, this
# syntax is NOT RECOMMENDED, because different packages may have functions that
# share the same names, but have a different functionality or behavior.

# Missing packages can be installed using the conda package manager. The eaxact
# procedure to install packages depends on your operating system. We will cover
# installation in the next tutorials.

#%% Reading in data

# Working directory:
# Every project typically has a file structure where your data, scripts, and
# reports are saved in their own (sub-)directories. The working directory is
# the folder where Python looks for data and other code, unless you specify to
# get it from somewhere else.
#
# When you start spyder, the working directory is your 'home' directory. You
# can check what your current working directory is by typing.
os.getcwd()

# Generally, it makes sense to set you working directory to the main folder of
# your project. Set your working directory using the chdir() function from the
# package 'os' which we imported above:
os.chdir('/home/chrenkl/Projects/programming_tutorials/Python/tutorial_01')
# (NOTE: you have to change this path to match you directory structure)

# We imported the pandas package above. In order to use its read_csv()
# function, we type the package and function name with a period - now it is
# obvious why we assigned an abbreviation to it.

# Read the file: 
ctd = pd.read_csv('data/D18667042_subset.csv')

# We now have the data in file 'D18667042_subset.csv', which is stored int the
# 'data' subdirectory, assigned to the variabel ctd. Let's check the data type:
type(ctd) # it is a pandas DataFrame

# You can have a look at it by double-clicking on the name 'ctd' in the
# variable explorer in the top right panel. A word of caution: do not try to
# inspect huge datasets.

# Instead you can print just the first five rows:
print(ctd.head())

# or the last 10 rows:
print(ctd.tail(10))

# You can also print one column:
print(ctd.pressure)

# Check the data type of the temperature column
print(type(ctd.salinity)) # it is a pandas Series

# A few more words about pandas DataFrames:
# You can think of them as a table with headers. They typically consist of one
# or more pandas Series (columns) which share the same indices. As we ill see
# in the upcoming tutorials, this index doesn't have to be an integer number.

# You can also print some summary statistics of each column
print(ctd.describe())

#%% Plotting

# Python itself does not have any functions to plot, but there are some
# packages which help you to create figures. The most common one is matplotlib.
import matplotlib.pyplot as plt

# plot the temperature column of our cdt DataFrame:
plt.plot(ctd.temperature)

# You should now see a figure with the index on the x-axis and temperature on
# the y-axis. We know that this is the temperature at different depths in the
# water column which we also have information of in the DataFrame (pressure is
# closely related to depth in the ocean). Therefore, it would be more intuitive
# to have temperature on the x-axis and pressure on the y-axis. We can achieve
# that by providing more arguments to the plot() function:
plt.plot(ctd.temperature, ctd.pressure)

# By default, the origin is in the lower left corner which makes sense for most
# data. In oceanography, depth is typically the (positive) distance from the
# sea surface and we therefore want to invert the y-axis. We will also parse
# more arguments to the plot function to make thee figure prettier:
plt.plot(ctd.temperature, ctd.pressure,
         color='g',
         linestyle='--',
         linewidth=2)

# invert y-axis
plt.gca().invert_yaxis()

plt.xlabel('Temperature')
plt.ylabel('Pressure')
plt.title('CDT Cast - Bedford Basin Monitoring Program')

# The pandas package comes with its own plotting capabilities. These are based
# on the standard plotting package matplotlib which gets called under the hood 
ctd.plot(x='temperature', y='pressure',
         color='g',
         linestyle='--',
         linewidth=2,
         title='CDT Cast - Bedford Basin Monitoring Program',         
         ylim=[70, 0])

# We can almost recreate the figure we plotted with matplotlib before. I prefer
# to use matplotlib because it gives you more flexibility. The plotting
# capabilities of pandas become very useful when you just want to have a quick
# look at your data.

#%% Getting help

# In order to get information about a package or function, you can use the help
# tab in the top right pane or the help() function:
help(os)
help(pd.DataFrame.plot)

# If you want to get a deeper understanding of how Python works and a more
# detailed guide how to use it, read through the SciPy Lectures:
# https://www.scipy-lectures.org/

# For more specific problems, consult the following ressources:
# 1. Other students (!!!)
# 2. Stackoverflow (or other code forums)
# 3. GitHub (or related code repositories)
# 4. Personal blogs
# 5. Open-source courses (Coursera, etc.)

# Google is your friend. Well-articulated searches will (hopefully) send you to
# the right place. Good luck, and don't be afraid to ask for help!

