## Tutorial 01: Intro to R ##

# This script is intended to provide an overview of some of the capabilities of R, with particular emphasis on tools required to succeed in oceanography. It's a working document, so please note or excuse any mistakes.

# R is a programming language. As such it is beautifully, and sometimes painfully logical. Be prepared to make mistakes and be frustrated, but we encourage you to stick with it long enough to recognize the power and efficiency of this tool.

# Quick tour --------------------------------------------------------------

# <- these hashtags denote 'comments', which are not noticed by R and intended to document your code

# Here are a few of the very basics:
# 1. This tutorial assumes you are using Rstudio in the default set up. Rstudio is not the same as R. R is the actual programming language, while Rstudio refers to a common, and very powerful interface for people to use R.
# 2. All the text you are reading is called the 'script'. This is just a text file (saved as .R) that contains the code that will be read and compiled R
# 3. Below is the console.
# 4. Top right is your global environment
# 5. Bottom right are tabs for help, plotting, package manager, etc

# I like to enter code directly into the script (here, where I'm typing), and then run this code 'line-by-line' using the keyboard shortcut command+enter (on a mac, probably similar on a PC). Other users might prefer to enter their code in the console and only move to the script what they would like to save for later. They also may opt to use the 'Run' button to run the entire script (or highlighted text) instead of the keyboard shortcut. There's no 'right way', you'll figure out a system that works for you.

# simple operations -------------------------------------------------------
# run through these steps line by line to see the answers appear in the console

# basic math
3+3 # addition
10*100 # multiplication
log10(10000) # log base 10
sqrt(64) # square root
(12-3)*10^(-1.5) # more complex operation
4/6

# variables ---------------------------------------------------------------

x = 12 # use the equals sign or arrow (<-) to assign a variable. This literally means, 'assign 12 to the variable named x'. Now you see x show up in the global environment
x <- 12

15 - x # viola!

# data types --------------------------------------------------------------

# ADD MORE HERE #

txt = 'hello world' # now the variable 'txt' shows up. Note that it's a character, not an integer
print(txt) # variable shows up in the console

# make a vector
vec1 = c(1,2,3,4,5,6,7,8)
vec2 = c(1,2,NA,4,5,6,7,8)
vec3 = c('cow','pig','horse','tugboat', 'pumpkin', 'gerbil', 'onion', 'bean')

# select a specfic value from vector (indexing)
vec1[1]
vec2[3]
vec3[4]

# make data frame
df = data.frame(vec1,vec2,vec3)

# functions ---------------------------------------------------------------

# manually calculate the mean of 'vec'
(1+2+3+4+5+6+7+8)/8

# use 'mean()' function
mean(vec1)

# calculate other descriptive statistics
sd(vec1)

# mean of a vector with a nan
mean(vec2)
mean(vec2, na.rm = TRUE)

# mean of non-numeric vector
mean(vec3)
mean(vec3, na.rm = TRUE)

# help functions
help(mean)

# or more simply
?mean
# Note: if you enter the function without parenthases you'll get the source code of the function (wayyy beyond the scope of this intro), or at least where R stores that info. This is what's going on under the hood.

# environment -------------------------------------------------------------

# we've added some things to the environment, which can get cluttered over time if you don't keep things tidy. You can remove variables one at a time using 
rm(x) # removes x
# you can also clear all variables by clicking on the little broom or running the line
rm(list=ls())
# you should 'comment this out' (i.e. put a hashtag in front) if you don't want R to do this.

# reading in data ---------------------------------------------------------

getwd() # get working directory
setwd("/Users/hansenjohnson/Documents/Courses/2017_winter/FO/introduction_to_R/") # set working directory to your desktop. This is the place on your computer where R 'lives' during your session, as in where it will look for files, save data, etc unless told otherwise. This file path might be quite different for your machine, particularly if it's a windows...

# go to brightspace and save the data file for the first tutorial to your desktop (i.e. your current 'working directory')
data = read.table("FO2017Tutor01.dat", sep = ',') # read in the .dat file for the tutorial assignment

# manipulating a data frame -----------------------------------------------
# we've imported some data, now let's look at it. Click the little table on the far right of the row in your global environment, or use the View() function

# it automatically named the columns strange values. let's rename
colnames(data) = c('time', 'col2')
# the c() tells R to expect multiple arguments (i.e. a list). time and col2 are now the column names

# use find replace (magnifying glass or command+f) to put in real column names

# let's look at only time
data$time # this is done using a dollar sign. It tells R to look for 'time' within the 'data' variable

# so we don't need to type data$time every time, let's assign it to an easy variable
c1 = data$time
c2 = data$col2

# plotting ----------------------------------------------------------------

# now let's try plotting the two variables against each other
plot(x = c1, y = c2, 
     col = 'purple', 
     pch = 16,
     main = 'Title', 
     xlab = 'x axis title', 
     ylab = 'y axis title')

## REPEAT WITH DIFFERENT DATA INPUT FILE ##
