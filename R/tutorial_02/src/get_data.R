## get_data ##
# get and manipulate data for use in tutorial 02

# download .csvp of realtime CTD data from CEOTR website here: http://ceotr.ocean.dal.ca/#/data/88

# read in raw data
df = read.csv('data/otn200_20180815_88_realtime_3977_cd22_d42e.csv')

# choose subset of desired variables
out = df[1:50000, c("time..UTC.","latitude..degrees_north.", "longitude..degrees_east.", "conductivity..S.m.1.",
           "temperature..Celsius.", "pressure..dbar.", "profile_id")]

# save data
write.csv(out, 'data/glider.csv', row.names = FALSE)
