## master ##
# download, process, and plot Slocum glider data

# user input --------------------------------------------------------------

# list urls to deployment data (choose deployments at
# http://ceotr.ocean.dal.ca/gliders/data)

data_urls = c(
  'http://belafonte.ocean.dal.ca:8080/erddap/tabledap/otn200_20180918_90_realtime.csvp?time%2Cdepth%2Clatitude%2Clongitude%2Cconductivity%2Ctemperature%2Csalinity%2Cdensity%2Cpressure%2Cprofile_id',
  'http://belafonte.ocean.dal.ca:8080/erddap/tabledap/otn200_20171216_80_delayed.csvp?time%2Cdepth%2Clatitude%2Clongitude%2Cconductivity%2Ctemperature%2Csalinity%2Cdensity%2Cpressure%2Cprofile_id',
  'http://belafonte.ocean.dal.ca:8080/erddap/tabledap/bond_20170911_77_delayed.csvp?time%2Cdepth%2Clatitude%2Clongitude%2Cconductivity%2Ctemperature%2Csalinity%2Cdensity%2Cpressure%2Cprofile_id')

# define directory structure
fig_dir = 'figures' # figures
proc_dir = 'data'   # processed data

# setup -------------------------------------------------------------------

# libraries
library(oce)
library(ocedata)

# read in data
data("coastlineWorldFine")

# load functions
source('src/functions.R')

# create directory structure
if(!dir.exists(fig_dir)){
  dir.create(fig_dir, recursive = TRUE)
}
if(!dir.exists(proc_dir)){
  dir.create(proc_dir, recursive = TRUE)
}

# process -----------------------------------------------------------------

# loop through all deployments and generate simple plots
for(i in seq_along(data_urls)){
  
  # isolate data url
  data_url = data_urls[i]
  
  ## extract deployment id from url (e.g., 'otn200_20180918_90_realtime')
  
  # split url by '/'
  tmp = strsplit(data_url, '/') 
  
  # isolate variable string
  tmp = tmp[[1]][6]
  
  # split url by '.csvp' to isolate deployment id
  tmp = strsplit(tmp, '.csvp') 
  
  # extract deployment id
  deployment_id = tmp[[1]][1]
  
  # define saved data file name
  ofile = paste0(proc_dir, '/', deployment_id, '.rds')
  
  if(!file.exists(ofile)){
    
    message('Reading data from:\n', data_url)
    
    # read in data
    df = read.csv(data_url)
    
    # rename columns
    colnames(df) = c('time', 'depth', 'lat', 'lng', 'conductivity', 'temperature', 
                     'salinity', 'density', 'pressure', 'profile_id')
    
    # format time
    df$time = as.POSIXct(df$time, format = '%Y-%m-%dT%H:%M:%SZ', tz = 'UTC')
    
    # remove NAs
    df = df[complete.cases(df),]
    
    # save data
    save(df, file = ofile)
  } else {
    message('Reading processed data from: ', ofile)
    load(ofile)
  }
  
  # plot time series --------------------------------------------------------
  
  # list variables to plot
  vars = c('temperature', 'salinity', 'density')
  
  # loop through and plot each variable
  for(j in seq_along(vars)){
    
    # isolate var name
    ivar = vars[j]
    
    # define file name
    fname = paste0(fig_dir, '/', deployment_id, '_', ivar, '.pdf')
    
    # start plot
    pdf(fname, height = 5, width = 7)
    
    # plot (using custom function)
    plot_time_series(df, var = ivar)
    
    # end plot
    dev.off()
  }
  
  # plot simple map ---------------------------------------------------------
  
  # determine center points of deployment
  mlon = median(df$lng)
  mlat = median(df$lat)
  span = 4 * 111 * diff(range(df$lat))
  
  # define file name
  mname = paste0(fig_dir, '/', deployment_id, '_map.pdf')
  
  # start plot
  pdf(mname, height = 5, width = 7)
  
  # plot basemap
  plot(coastlineWorldFine, clon = mlon, clat = mlat, span = span, 
       projection="+proj=merc", col = 'lightgrey')
  
  # add track lines
  mapLines(df$lng, df$lat, col = 'blue')
  
  # stop plot
  dev.off()
}