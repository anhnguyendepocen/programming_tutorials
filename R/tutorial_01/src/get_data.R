## get_data.R ##
# Download and save data used in tutorial 01

# user input --------------------------------------------------------------

# output file path
ofile = 'data/ctd.csv'

# process -----------------------------------------------------------------

# libraries
library(oce)
library(ocedata)

# read in data
data(ctd)

# explore ctd object
summary(ctd)

# isolate temperature
temperature = ctd[['temperature']]

# isolate depth
depth = ctd[['depth']]

# isolate salinity
salinity = ctd[['salinity']]

# isolate time (seconds since start)
time = ctd[['scan']]

# convert to data frame
dat = data.frame(time, depth, temperature, salinity)

# save temperature data to file
write.csv(dat, file = ofile, row.names = FALSE)

