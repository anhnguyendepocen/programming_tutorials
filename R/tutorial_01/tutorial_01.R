## Tutorial 01: Intro to R ##
# Follow along at: https://christophrenkl.github.io/programming_tutorials/

# This script is intended to provide an overview of some of the capabilities 
# of R, with particular emphasis on tools required to succeed in oceanography. 
# It's a working document, so please note or excuse any mistakes. Better yet, 
# file an issue to report them via to hansen.johnson@dal.ca 

# R is a programming language. As such it is beautifully, and sometimes 
# painfully logical. Be prepared to make mistakes and be frustrated, but we 
# encourage you to stick with it long enough to recognize the power 
# and efficiency of this tool.

# Tour of Rstudio ---------------------------------------------------------

# <- these hashtags denote 'comments', which are not noticed by R 
# and intended to document your code

# Here are a few of the very basics:
# 1. This tutorial assumes you are using Rstudio in the default set up.
#   Rstudio is not the same as R. R is the actual programming language, while
#   Rstudio refers to a common, and very powerful interface for people to 
#   use R.
# 2. All the text you are reading is called the 'script'. This is just 
#   a text file (saved as .R) that contains the code that will be read 
#   and compiled R
# 3. Below is the console.
# 4. Top right is your global environment
# 5. Bottom right are tabs for help, plotting, package manager, etc

# I like to enter code directly into the script (here, where I'm typing),
# and then run this code 'line-by-line' using the keyboard shortcut 
# command+enter (on a mac, probably similar on a PC). Other users might
# prefer to enter their code in the console and only move to the script 
# what they would like to save for later. They also may opt to use the 
# 'Run' button to run the entire script (or highlighted text) instead of 
# the keyboard shortcut. There's no 'right way', you'll figure out a 
# system that works for you.

# Simple operations -------------------------------------------------------

# basic math
3+3 # addition
10*100 # multiplication
log10(10000) # log base 10
sqrt(64) # square root
(12-3)*10^(-1.5) # more complex operation
4/6

x = 12 # use the equals sign or arrow (<-) to assign a variable. 
# This literally means, 'assign 12 to the variable named x'. 
# Now you see x show up in the global environment

x <- 12 # the arrow (<-) works the same way

15 - x # viola!

# we've added some things to the environment, which can get cluttered 
# over time if you don't keep things tidy. You can remove variables one 
# at a time using 

rm(x) # removes x

# you can also clear all variables by clicking on the little broom 
# or running the line

rm(list=ls())

# you should 'comment this out' (i.e. put a hashtag in front) if you 
# don't want R to do this.

# Data types --------------------------------------------------------------

txt = 'hello world' # now the variable 'txt' shows up. 

print(txt) # variable shows up in the console

# Note that it's a character, not an integer. This is one of many data types. 
# Here are a few common ones:
a = 3.112222 # numeric
b = 'cat' # character
c = TRUE # logical

# you can check the data type using the function class()
class(c)

# These are single value data types, which can be stored or organized in many formats
# Here, for example, are several 'vectors':
vec1 = c(1,2,3,4,5,6,7,8)
vec2 = c(1,2,NA,4,5,6,7,8)
vec3 = c('cow','pig','horse','tugboat', 'pumpkin', 
  'gerbil', 'onion', 'bean') # notice this vector is easily split over multiple lines

# Several vectors can be combined into a 'data frame', similar to a spreadsheet in excel
# Here's how to make data frame
df = data.frame(vec1,vec2,vec3)
# Notice that a data frame can hold multiple data types. This is very powerful.
# You can look at it by clicking on the icon next to 'df', or using the View() function
View(df)

# Introduction to functions -----------------------------------------------

# manually calculate the mean of 'vec'
(1+2+3+4+5+6+7+8)/8

# use 'mean()' function
mean(vec1)

# calculate other descriptive statistics
sd(vec1)

# mean of a vector with a nan
mean(vec2)
mean(vec2, na.rm = TRUE)
mean(na.rm = TRUE, x = vec2)
mean(vec2,0,TRUE)
mean()

# mean of non-numeric vector
mean(vec3)
mean(vec3, na.rm = TRUE)

# help functions
help(mean)

# or more simply
?mean
# Note: if you enter the function without parenthases you'll get the 
# source code of the function (wayyy beyond the scope of this intro), 
# or at least where R stores that info. This is what's going on under 
# the hood.

# Reading in data ---------------------------------------------------------

# The first step is to get or set the 'working directory'. This is the 
# place on your computer where R 'lives' during your session, as in where it
# will look for files, save data, etc unless told otherwise. This file 
# path might be quite different for your machine, particularly if it's 
# a windows...

# This is where R is currently working
getwd()

# Set the directory this way, or using the 'Files' tab, navigating to the
# appropriate place on your machine, then clicking 'More' and 
# 'Set as Working Directory'. Also, be sure to take advantage of tab
# autocomplete in Rstudio!
setwd() 

# read in the .csv file for the tutorial assignment
ctd = read.csv("data/ctd.csv") 

# we've imported some data, now let's look at it. Click the little table on 
# the far right of the row in your global environment, or use the View() function

# get summary of object 'structure'
str(ctd)

# get summary of data within object
summary(ctd)

# let's look at only time. This is done using a dollar sign. It tells R to look for 'time' 
# within the 'ctd' data frame. Note that 'time' here is expressed in seconds since the 
# instrument was turned on.
ctd$time 

# repeat for temperature
ctd$temperature 

# Plotting ----------------------------------------------------------------

# plot the entire data frame
plot(ctd)

# now let's try plotting two variables against each other
plot(x = ctd$time,
     y = ctd$temperature, 
     type = 'l',
     col = 'purple', 
     pch = 16,
     main = 'Title', 
     xlab = 'x axis title', 
     ylab = 'y axis title')

# Getting help ------------------------------------------------------------

# The following are very common places where help can be found:
# 1. Other students (!!!)
# 2. Stack overflow (or other code forum)
# 3. GitHub (or related code repository)
# 4. Rstudio website
# 5. Personal blogs
# 6. Open-source courses (Coursera, etc)

# Google is your friend. Well-articulated searches will (hopefully) send you to
# the right place. Good luck, and don't be afraid to ask for help :)