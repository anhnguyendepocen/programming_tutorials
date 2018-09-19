## Tutorial 02: Basic data wrangling ##

# This script is intended to provide an overview of some data wrangling in R.
# 'Data wrangling' is a catch-all term for actions involving accessing,
# manipulating, cleaning data in R. There are myriad ways to do this in R. The
# goal here is not to show what is right or wrong, but to introduce a few
# concepts and tools that the authors find useful in their own work.

# Keyboard shortcuts ------------------------------------------------------

# A key to efficiency and maintaining sanity in R, or any programming language,
# is to use keyboard shortcuts. Note these are specific to a mac, and can be
# customized. Here are a few of the most helpful:
# - undo (command + z)
# - redo (command + shift + z)
# - find (command + f)
# - save script (command + s)
# - jump to front/end of line (command + left arrow // command + left arrow)
# - jump by word (option + left arrow // option + left arrow)
# - toggle comments (command + shift + c)
# - reflow comments (command + shift + /)
# - source script (command + shift + s)
# - automatic indenting (control + i)
# - switch scripts (control + option + left/right arrow)

# Data exploration --------------------------------------------------------

# Start by reading in the data. This data is from a recent Slocum glider mission
# in Roseway Basin, a relatively small, shallow (~180m) Basin off of Southwest
# Nova Scotia. Slocum gliders are autonomous underwater vehicles that swim up
# and down in the water column for weeks to months at a time measuring various
# ocean properties. The data we have here are from the CTD, which measures
# temperature, conductivity and depth, as well as the GPS, which records the
# latitude and longitude of the glider. As these are common variables in
# Oceanography, it's as good a place as any to get started. For more details,
# see the 'get_data.R' script.

# read in the csv data
df = read.csv('data/glider.csv')

# examine data structure
str(df)

# this tells us we have a data frame with 50,000 observations of 7 variables. We
# also see that there are several data types and several NAs, which will become
# important very soon.

# quick summary
summary(df)

# this gives us a glimpse of the basic descriptive stats of (some of) the data.
# Note that the results here are not very meaningful for 'time' and 'profile_id'
# columns because they are not in the correct data format

# view the first few lines of the data frame
head(df)

# here we get a sense of the data format, and notice that the CTD variables
# appear to have 'real' values less frequently than the GPS or time data. We'll
# need to take this into account soon.

# it can also be helpful to view the last lines of the frame with tail()
tail(df)

# verify the data class (we already know from the call to str() above)
class(df)

# list the column names
names(df)

# the column names are very informative here because they have both the variable
# name and the measurement unit.

# General formatting ------------------------------------------------------

# It's great that the column names are so informative, but they're long and
# cumbersome to type if we need to reference them by name (which I like to do).
# Let's rename them something easier. I do that with colnames()
colnames(df) = c('time', 'lat', 'lng', 'conductivity', 'temperature', 
                 'pressure', 'profile_id')

# Now let's reformat the data types that are incorrect. Let's start looking at
# profile_id

# check data type of profile_id
class(df$profile_id)

# It's currently an integer. This could be helpful in some applications, but for
# the sake of argument let's say e want it to serve as more of label that we can
# use to group profiles rather than a number. Let's change it to a 'factor':
tmp = as.factor(df$profile_id)

# check to make sure it worked
head(df$profile_id)
head(tmp)

# the '612' levels tells us that this dataset has 612 different profiles.

# We're satisfied that this worked, so let's overwrite column variable
df$profile_id = tmp

# check data frame structure again to verify
str(df)

# The same basic steps can be used to convert between most data formats using
# the following functions:
# as.numeric()
# as.integer()
# as.character()
# as.logical()
# ...
# This is usually straightforward, but be cautious because sometimes information
# is lost in the conversion. Just to demonstrate let's try to convert it back to
# an integer and see what happens
tmp = as.integer(df$profile_id)

# let's look at the results
head(tmp)

# notice that these integers are not the same as the original. Instead, they are
# a direct translation of the factor level. This is ugly, but if we want the
# original numbers we have to first convert to character, then to integer.
tmp = as.character(df$profile_id)
tmp = as.integer(tmp)
head(tmp) # success!

# you can also achieve the same in a single line by placing one function inside
# another. This is nice for concision, but it can quickly become unreadable:
tmp = as.integer(as.character(df$profile_id))
head(tmp) # success!

# Formatting date/time ----------------------------------------------------
# Working with dates and times is so treacherous, but so important, that it
# deserves its own section

# let's look at the first few values
head(df$time)

# currently it's in a factor format. We'll need to correct that. Also note the
# formatting convention (e.g., '2018-08-15T15:53:23Z')

# R uses the 'POSIX' format for time. Convert to POSIX using the function
# as.POSIXct(). Let's try that out.
tmp = as.POSIXct(df$time)

# No errors, but let's check to make sure it worked
head(tmp)

# These do NOT line up with what we expect, meaning we did not do the conversion
# correctly. The problem is that the timestamp we provided is in a format that R
# didn't recognize. Instead of printing an error (which would have been better),
# it blindly applied the default conversion and got it wrong. Silly R!

# Let's try the conversion again, but explicitly tell R which format to use. For
# that, we'll use the 'format' argument of the as.POSIXct() function. We'll also
# use the tz argument to specify the timezone as UTC
tmp = as.POSIXct(df$time, format = '%Y-%m-%dT%H:%M:%SZ', tz = 'UTC')

# The '%Y-%m-%dT%H:%M:%SZ' part above tells R how to interpret the timestamp.
# The details can be found here:
?strptime()

# Let's compare again
head(df$time)
head(tmp)

# Looks good! Now the final step is to overwrite the column in our table with
# the correct time values in POSIX format. That's done with the following:
df$time = tmp

# Once again, verify it's all looking good with a str() call
str(df)

# Subsetting and indexing -------------------------------------------------

# Subsetting and indexing are CRITICALLY important skills for data wrangling.
# Let's start with subsetting, which is the simple act of selecting a 'subset'
# of data from the full dataset that satisfy a given set of conditions.

# Here are a few subset examples using the subset() function. This also
# introduces a few new operators like <, >=, !, and ==

# temperature less than 10
df_1 = subset(df, temperature < 10)

# temperature exactly equal to 10
df_2 = subset(df, temperature == 10) 

# temperature greater than or equal to 10
df_3 = subset(df, temperature >= 10) 

# temperature greater than n
n = 7
df_4 = subset(df, temperature > n) 

# temperature greater than or equal to 10 AND pressure less than 30
df_5 = subset(df, temperature >= 10 & pressure < 30) 

# temperature NOT greater than or equal to 8
df_6 = subset(df, !temperature >= 8)

# 'Indexing' is the practice of selecting ordered data based on it's position in
# the data structure. That's a vacuous definition. Hopefully these examples will
# help.

# select the first value from a vector
tmp[1]

# 1000th value from a vector
tmp[1]

# nth value from a vector
n = 27
tmp[n]

# values 1 to 3 from a vector
tmp[1:3]

# values 7 to 9 and 1000 to 1004 from a vector
tmp[c(7:9,1000:1004)]

# vector WITHOUT the 10th value
tmp[-10]

# vector WITHOUT the 2nd to last value
tmp[-(2:50000)]
tmp[-(2:length(tmp))] # same as above, but uses the length() function to find the last value

# the same types of operations are also possible with a dataframe, but now with
# both a row and column coordinate. Remember the convention df[row,column]!

# select all values in the 2nd column (latitude)
df[,2]

# select all values in the 100th row
df[100,]

# select the value in the 3rd row, 7th column
df[3,7]

# select all data in rows 1:5
df[1:5,]

# select all data in columns 1 and 3 through 5
df[,c(1,3:5)]

# remove rows 3 through 49999, and columns 1 through 3
df[-(3:49999),1:3]

# remove all but first 2 rows, and only columns 3 through 7
df[-(3:50000),3:7]
df[-(3:nrow(df)),3:ncol(df)] # this uses nrow and ncol to determine dimension of df

# also, VERY handy, you can also select columns by name

# first 10 rows of columns named 'time','lat', and 'lng'
df[1:10,c('time','lat', 'lng')]

# To bring it all together, indexing can also be used for subsetting!

# temperature greater than 10 and longitude less than or equal to -63
df[df$temperature>10 & df$lng<=-63,]

# temperature greater than 10 and less than or equal to 11
df[df$temperature>10 & df$temperature<=11,]

# Packages ----------------------------------------------------------------

# R and Python are open-source language, which means that it's freely available,
# as opposed to languages like MATLAB, IDL, and others that are propriatary and
# require expensive licenses. One of the great benefits to the open source is
# that people can contribute code that they have written for their own purposes.
# These contributions are organized in libraries and accessed on one of many
# online repositories. We'll try to demonstrate how to use such libraries in this
# tutorial to extend the capabilities of basic R.

# Given this is an oceanography tutorial at Dal, I can't help but start with the
# 'oce' package. This package was developed by Dan Kelley (5th floor) and his
# students for oceanographic analysis, and it's awesome! Let's try to get it
# up and running.

# Using libraries is a two-step process. First, they must be installed. This
# only needs to be done once, and can be done using the packages tab on the
# bottom right pane of Rstudio, or via the script with a call to the
# install.packages() function

# install.packages('oce') # uncomment this line to install from the script

# Second, they must be 'called', or loaded into the current R session in order
# to be used. This is done with the library() function below:
library(oce)

# These two steps are often combined with the function require()
require(oce)

# Convert CTD units -------------------------------------------------------

# We'll now use a few functions from the oce package to convert our CTD data
# into meaningful units.

# Let's start by converting pressure (measured in 'dbars', or 'decibars') to
# depth in meters. Oce has a function for this called  swDepth(), which uses
# pressure and latitude to calculate depth.

# Check out the documentation for the function
help(swDepth)

# Execute the function
depth = swDepth(pressure = df$pressure, latitude = df$lat)
# Success! And note that it gracefully handles all the NAs - nice work Dan!

# Let's store this in our data frame as a new column called 'depth'
df$depth = depth

# Now let's calculate salinity using the function swSCTp(). This requires
# several inputs, which I'll split over multiple lines. It also requires knowing
# the unit for the conductivity measurements. Recall that the original column
# was named 'conductivity..S.m.1.', and I know that means the units for
# conductivity are "S/m". For efficiency, let's store it directly as a column in
# the data frame
df$salinity = swSCTp(conductivity = df$conductivity, 
                     temperature = df$temperature, 
                     pressure = df$pressure, 
                     conductivityUnit = "S/m") 

# Finally, let's calculate the density using the function swRho()
df$density = swRho(salinity = df$salinity, 
                   temperature = df$temperature, 
                   pressure = df$pressure, 
                   longitude = df$lng, 
                   latitude = df$lat)

# Subset in time ----------------------------------------------------------

# check the time range of your data
range(df$time)

# choose start time
t0 = as.POSIXct('2018-08-17 01:22:37', tz = 'UTC')

# choose end time
t1 = as.POSIXct('2018-08-18 13:22:37', tz = 'UTC') # specific end time
t1 = t0+60*60*12 # choose end time by adding time, in seconds, to the start time

# complete subset
dfs = subset(df, time > t0 & time < t1)


# Plot 1: full deployment -------------------------------------------------

# The first thing to do is get rid of the NA's - these are not helpful for
# these plotting purposes. This is quickly achieved with the complete.cases()
# function, which reviews data and returns only lines without NAs. Here I'm 
# applying it to the rows in our data frame, which will exclude all rows that
# have an NA
df = df[complete.cases(df),]
dfs = dfs[complete.cases(dfs),]

# Now we're ready to plot! Let's start by plotting full profile (time vs depth)
plot(df$time, df$depth, type = 'l', col = 'grey', xlab = '', ylab = 'Depth [m]')

# That looks nice, but the depth is backwards! Let's fix that by reversing the y axis limits. This is also getting long, so I'll split it over multiple lines
plot(x = df$time, 
     y = df$depth, 
     type = 'l', 
     col = 'grey', 
     xlab = '', 
     ylab = 'Depth [m]', 
     ylim = rev(range(df$depth)))

# Now let's add the subsetted layer on top in blue
lines(dfs$time, dfs$depth, col = 'blue')

# Plot 2: subset ----------------------------------------------------------

# Now let's create a second plot that zooms in on our subset
plot(x = dfs$time, 
     y = dfs$depth, 
     type = 'l', 
     col = 'blue', 
     xlab = '', 
     ylab = 'Depth [m]', 
     ylim = rev(range(df$depth)))

# Let's add points to the line so we can see where the points were drawn
points(x = dfs$time, y = dfs$depth, col = 'black', cex = 0.3)

# Now let's add a legend
legend("bottomleft", 
       lty = c(NA, 1), 
       pch = c(1, NA), 
       col = c('black', 'blue'), 
       legend = c('Data point', 'Glider track'), 
       bty = 'n',
       cex = 0.7)

# Now let's make a text label to print the timestamp. The paste0 function is
# incredibly useful for combining text and data values into a text string
txt = paste0('Glider profiles from ', t0, ' to ', t1)

# check it out
txt

# Add it to the top left margin of the plot
mtext(text = txt, side = 3, line = 0, adj = 0, cex = 0.8)


# Plot and save glider profiles -------------------------------------------
# Now we're going to use the code above to save both plots in a single figure.

# The first step is to define the file to save. We'll save a jpeg. Once this line is entered it effectively 'opens' an image file. Anything that's sent to the graphics pane will instead be written to the file.
jpeg(filename = 'glider.jpg', width = 5, height = 7, units = 'in', res = 150)

# Split the graphics pane into 2 rows x 1 column
par(mfrow = c(2,1))

# plot 1: full deployment
plot(x = df$time, 
     y = df$depth, 
     type = 'l', 
     col = 'grey', 
     xlab = '', 
     ylab = 'Depth [m]', 
     ylim = rev(range(df$depth)))

# highlight subset
lines(dfs$time, dfs$depth, col = 'blue')

# plot 2: close up on subset
plot(x = dfs$time, 
     y = dfs$depth, 
     type = 'l', 
     col = 'blue', 
     xlab = '', 
     ylab = 'Depth [m]', 
     ylim = rev(range(df$depth)))

# add data points
points(x = dfs$time, y = dfs$depth, col = 'black', cex = 0.3)

# add legend
legend("bottomleft", 
       lty = c(NA, 1), 
       pch = c(1, NA), 
       col = c('black', 'blue'), 
       legend = c('Data point', 'Glider track'), 
       bty = 'n',
       cex = 0.7)

# add text
mtext(text = txt, side = 3, line = 0, adj = 0, cex = 0.8)

# Now that we've produced the plots, the last step is to 'close' the open jpeg
# file. That's done with a call to dev.off()
dev.off()

# Go to your working directory on your computer. You should now see a nice
# figure saved!

# Plot and save CTD profiles ----------------------------------------------
# Now we're going to create side by side temperature and salinity plots

# Uncomment this when you're ready to save
# jpeg(filename = 'ctd.jpg', width = 7, height = 5, units = 'in', res = 150)

# Split the graphics pane into 1 row x 2 columns
par(mfrow = c(1,3))

# plot 1: temperature of subset
plot(x = dfs$temperature, 
     y = dfs$depth, 
     type = 'l', 
     col = 'red', 
     xlab = 'Temperature [°C]', 
     ylab = 'Depth [m]', 
     ylim = rev(range(df$depth)))

# add grid
grid()

# plot 2: salinity of subset
plot(x = dfs$salinity, 
     y = dfs$depth, 
     type = 'l', 
     col = 'darkgreen', 
     xlab = 'Salinity', 
     ylab = 'Depth [m]', 
     ylim = rev(range(df$depth)))

# add grid
grid()

# plot 3: density of subset
plot(x = dfs$density, 
     y = dfs$depth, 
     type = 'l', 
     col = 'blue', 
     xlab = 'Density [kg/m3]', 
     ylab = 'Depth [m]', 
     ylim = rev(range(df$depth)))

# add grid
grid()

# uncomment this when you're ready to save
# dev.off()

# Saving R data files for later -------------------------------------------

# We've done a lot of work wrangling this data. The next step is to save it so
# we can access it easily next time. We could simply run this script again to
# repeat the entire process, but that can be time consuming and complicated with
# larger projects. A good solution is to save the data in a format that R
# recognizes, can read easily, and will preserve all the data types and
# formatting. There are two options for R data formats: .rda and .rds files. The
# only practical difference is that .rda files save multiple objects with the
# names provided, but .rds files save just a single object without a name. For
# this tutorial we'll just use a .rda file.

# Let's save our data frame 'df'
save(df, file = 'processed.rda')

# Now let's test it. First, wipe the environment
rm(list=ls())

# Now, load the saved data
load('processed.rda')

# Our saved data frame is back exactly as we'd left it, and ready for more analysis!

# That's all for today, happy coding!