get_glider_data = function(deployment_id = 'Fundy_20180913_89_realtime', data_dir = 'data/raw/', proc_dir = 'data/processed/'){
  
  # libraries
  library(oce)
  library(ocedata)
  
  # create directory structure
  if(!dir.exists(data_dir)){
    dir.create(data_dir, recursive = TRUE)
  }
  if(!dir.exists(proc_dir)){
    dir.create(proc_dir, recursive = TRUE)
  }
  
  # assemble url
  data_url = paste0("http://belafonte.ocean.dal.ca:8080/erddap/tabledap/", deployment_id, ".csvp?time%2Cdepth%2Clatitude%2Clongitude%2Cconductivity%2Ctemperature%2Csalinity%2Cdensity%2Cpressure%2Cprofile_id")
  
  # define raw and data file names
  ifile = paste0(data_dir, '/', deployment_id, '.csv')
  ofile = paste0(proc_dir, '/', deployment_id, '.rds')
  
  if(!file.exists(ofile)){
    
    # download data
    if(!file.exists(ifile)){
      download.file(url = data_url, destfile = ifile)
    }
    
    # read in data
    df = read.csv(ifile)
    
    # rename columns
    colnames(df) = c('time', 'depth', 'lat', 'lon', 'conductivity', 'temperature', 
                     'salinity', 'density', 'pressure', 'profile_id')
    
    # format time
    df$time = as.POSIXct(df$time, format = '%Y-%m-%dT%H:%M:%SZ', tz = 'UTC')
    
    # make date column
    df$date = as.Date(df$time)
    
    # remove NAs
    df = df[complete.cases(df),]
    
    # save data
    saveRDS(df, file = ofile)
    return(df)
    
  } else {
    message('Reading processed glider data from:\n', ofile)
    df = readRDS(ofile)
    return(df)
  }
}

plot_time_series = function(df, var='temperature', npoints = 20000){
  
  # subset data if necessary
  if(nrow(df)>npoints){
    
    norig = nrow(df)
    nsub = round(norig/npoints,0)
    df = df[seq(1, nrow(df), nsub),] # subset to plot every other data point
    
    message('NOTE - only plotting a subset because there are more than ', 
            npoints, ' points')
  } else {
    df
  }
  
  # setup layout for plotting
  m = rbind(c(1,1,1,1,1,1,1,1,1,1,1,2),
            c(1,1,1,1,1,1,1,1,1,1,1,2),
            c(1,1,1,1,1,1,1,1,1,1,1,2),
            c(1,1,1,1,1,1,1,1,1,1,1,2),
            c(1,1,1,1,1,1,1,1,1,1,1,2),
            c(1,1,1,1,1,1,1,1,1,1,1,2))
  
  # switch for variable
  if(var == 'temperature'){
    pal = oce.colorsTemperature()
    lab = 'Temperature [deg C]'
    zlim = range(df$temperature)
    c = colormap(df$temperature, breaks=100, zclip = T, col = pal, zlim = zlim)
  } else if(var == 'salinity'){
    pal = oce.colorsSalinity()
    lab = 'Salinity'
    zlim = range(df$salinity)
    c = colormap(df$salinity, breaks=100, zclip = T, col = pal, zlim = zlim)
  } else if(var == 'density'){
    pal = oce.colorsDensity()
    lab = 'Density [kg/m3]'
    zlim = range(df$density)
    c = colormap(df$density, breaks=100, zclip = T, col = pal, zlim = zlim)
  } else {
    stop('Unknown variable! Please choose from: temperature, salinity, or density')
  }
  
  # set layout for plotting
  layout(m)
  
  # plot section
  plot(df$time, df$depth, 
       ylim = rev(range(df$depth)), 
       type = 'l', 
       col = 'grey', 
       ylab = 'Depth [m]', 
       xlab = '', 
       xaxt = 'n')
  
  # add point coloured by variable level
  points(df$time, df$depth, pch = 21, bg = c$zcol, cex = 1, col = NULL)
  
  # add nicer time axis
  axis.POSIXct(side = 1, x = df$time, format = '%b-%d')
  
  # add variable label
  mtext(paste0(lab),side = 3, line = 1, adj = 0)
  
  # add colour palette
  drawPalette(c$zlim, col=c$col, breaks=c$breaks, zlab = '', fullpage = T)
  
}

glider_to_section = function(df, profile0 = NA, profile1 = NA){

  library(oce)
  
  # split dataset by profiles
  profile_list = split(x = df, f = df$profile_id)
  
  # remove ascending profiles
  # downcasts = lapply(profile_list, FUN = function(x){
  #   if((x$depth[1]-x$depth[2]) > 0){
  #     x
  #   }
  # })
  
  # convert each profile to a ctd object
  profiles = lapply(profile_list, FUN = function(x){
    as.ctd(
      salinity = x$salinity,
      temperature = x$temperature, 
      pressure = x$pressure, 
      conductivity = x$conductivity, 
      latitude = x$lat, 
      longitude = x$lon, 
      time = x$ time
    )
  })
  
  # extract vector of min depths of each profile
  tops = unlist(lapply(profiles, function(x) min(x@data$pressure, na.rm=T)))
  
  # remove all profiles with a start depth below 15 dbar
  tst1 = which(tops>15)
  if(length(tst1)>0){
    profiles = profiles[-tst1]  
  }
  
  # extract vector of length of each profile
  npts = unlist(lapply(profiles, function(x) length(x@data$pressure)))
  
  # remove all profiles with fewer than 7 points
  tst2 = which(npts<7)
  if(length(tst2)>0){
    profiles = profiles[-tst2]  
  }
  
  # convert to section
  if(!is.na(profile0) & !is.na(profile1)){
    # subset
    sec = as.section(profiles[profile0:profile1])
  } else {
    # full dataset
    sec = as.section(profiles)
  }
  
  return(sec)
}

plot_section = function(df, z_bin = 0.5, z_max = 100, var = 'temperature'){
  
  library(oce)
  
  # covnert to section
  sec = glider_to_section(df)
  
  # grid profiles into depth bins from 0 to desired depth
  sg = sectionGrid(sec, p=seq(from = 0, to = z_max, by = z_bin)) 

  # define empty vectors
  nstation <- length(sg[['station']])
  p <- unique(sg[['pressure']])
  np <- length(p)
  dL <- array(NA, dim = c(nstation, 2)) # pull out lat lon of each profile
  Temp <- array(NA, dim=c(nstation, np))
  Sal <- array(NA, dim=c(nstation, np))
  St <- array(NA, dim=c(nstation, np))
  time <- rep(NA, nstation)

  for (i in 1:nstation) {
    temperature = sg[['station']][[i]][['temperature']]
    salinity = sg[['station']][[i]][['salinity']]
    pressure = sg[['station']][[i]][['pressure']]
    latitude = sg[['station']][[i]][['latitude']]
    longitude = sg[['station']][[i]][['longitude']]
    rho = swRho(salinity, temperature, pressure, latitude, longitude)
    
    Temp[i, ] <- temperature
    Sal[i, ] <- salinity
    St[i, ] <- rho
    dL[i, 1] <- min(longitude, na.rm = T)
    dL[i, 2] <- min(latitude, na.rm = T)
    time[i] <- mean(sg[['station']][[i]][['time']], na.rm = T)
  }

  # convert time
  time = as.POSIXct(time, origin = '1970-01-01 00:00:00', tz = 'UTC')

  # plot
  if(var == 'temperature'){
    imagep(x = time, y = p, z = Temp, decimate = FALSE, col = oce.colorsTemperature, flipy = T)
  } else if(var == 'salinity'){
    imagep(x = time, y = p, z = Sal, decimate = FALSE, col = oce.colorsSalinity, flipy = T)
  } else if(var == 'density'){
    imagep(x = time, y = p, z = rho, decimate = FALSE, col = oce.colorsDensity, flipy = T)
  } else {
    stop('Unknown variable! Please choose from: temperature, salinity, or density')
  }

}

glider_sst = function(ndate, df, z_lim = 5){
  
  # define date
  ndate = as.Date(ndate)

  # subset glider data for date and surface
  dt = df[as.character(df$date) == as.character(ndate) & df$depth < z_lim,]
  
  if(nrow(dt) != 0){
    # determine median lat
    mlat = median(dt$lat, na.rm = TRUE)
    
    # determine median lon
    mlon = median(dt$lon, na.rm = TRUE)
    
    # determine distances to each point from median
    dt$dist = geodDist(longitude1 = dt$lon, latitude1 = dt$lat, longitude2 = mlon, latitude2 = mlat)
    
    # index of closest point
    ind = which.min(dt$dist)
    
    # return temp at shortest distance
    out = data.frame(date = dt$date[ind],
                     lat = dt$lat[ind], 
                     lon = dt$lon[ind],
                     temperature = dt$temperature[ind])
    
    return(out)
    
  } else {
    message('No data found!')
    
    out = data.frame(date = ndate,
                     lat = NA, 
                     lon = NA,
                     temperature = NA)
    
    return(out)
  }
}
