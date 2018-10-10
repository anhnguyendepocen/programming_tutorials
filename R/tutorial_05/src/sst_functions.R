get_sst_data = function(date, data_dir = 'data/raw/', proc_dir = 'data/processed/'){
  # download and process sst data
  
  # libraries
  library(ncdf4)
  
  # convert date
  date = format(as.Date(date), '%Y%m%d')
  
  # make data directory
  if(!dir.exists(data_dir)){dir.create(data_dir, recursive = TRUE)}
  
  # make data directory
  if(!dir.exists(data_dir)){dir.create(proc_dir, recursive = TRUE)}
  
  # assemble url to query NOAA database
  url_base = paste0("https://www.ncei.noaa.gov/data/sea-surface-temperature-optimum-interpolation/access/", date, "120000-NCEI/0-fv02/")
  url_file = paste0(date, "120000-NCEI-L4_GHRSST-SSTblend-AVHRR_OI-GLOB-v02.0-fv02.0.nc")
  
  # define data url
  data_url = paste0(url_base, url_file)
  
  # define data file
  data_file = paste0(data_dir, url_file)
  
  # define output file
  ofile = paste0(proc_dir, date, '_sst.rds')
  
  if(!file.exists(ofile)){
    
    # download netcdf
    if(!file.exists(data_file)){
      download.file(url = data_url, destfile = data_file)
    } else {
      message('SST data already downloaded! Located at:\n', data_file) 
    }
    
    # open netcdf file and extract variables
    nc = nc_open(data_file)
    
    # view netcf metadata
    # print(netcdf)
    
    # extract data
    lat = ncvar_get(nc, "lat")
    lon = ncvar_get(nc, "lon")
    time = ncvar_get(nc, "time")
    sst = ncvar_get(nc, "analysed_sst")
    
    # close netcdf
    nc_close(nc)
    
    # convert timestamp
    time = as.POSIXct(time, origin = '1981-01-01 00:00:00', tz = 'UTC')
    
    # convert units from kelvin to celcius
    sst = sst - 273.15
    
    # make list to hold output
    sat = list()
    sat$lat = lat
    sat$lon = lon
    sat$sst = sst
    sat$time = time
    
    # save data
    saveRDS(object = sat, file = ofile)
    
  }else{
    message('Reading processed SST data from:\n', ofile)
    sat = readRDS(ofile)
  }
  
  # return output
  return(sat)
}

calc_bb = function(lat, lon, lat_buffer = 0, lon_buffer = 0){
  # calculate bounding box for array of lat/lons
  
  # determine limits of glider deployment
  bb = data.frame(
    xmin = round(min(lon, na.rm = TRUE)-lon_buffer),
    xmax = round(max(lon, na.rm = TRUE)+lon_buffer),
    ymin = round(min(lat, na.rm = TRUE)-lat_buffer),
    ymax = round(max(lat, na.rm = TRUE)+lat_buffer)
  )
  
  return(bb)
}

subset_sst = function(sat, bb){
  # extract sst within a bounding box
  
  # determine subset indices
  ilat = which(sat$lat >= bb$ymin & sat$lat <= bb$ymax)
  ilon = which(sat$lon >= bb$xmin & sat$lon <= bb$xmax)
  
  # make a list to hold output
  out = list()
  
  # subset
  out$lat = sat$lat[ilat]
  out$lon = sat$lon[ilon]
  out$sst = sat$sst[ilon,ilat]
  out$time = sat$time
  
  return(out)
}

plot_sst = function(sat, colorbar = TRUE){
  # plot a map of an sst object
  
  library(oce)
  library(ocedata)
  
  # define variables
  sst = sat$sst
  lat = sat$lat
  lon = sat$lon
  time = sat$time
  
  # check map span to determine required coastline resolution
  if(abs(diff(range(lat))) >= 10 | abs(diff(range(lon))) >= 10){
    data("coastlineWorld")
    cl = coastlineWorld
    p = "+proj=eck3"
  } else {
    data("coastlineWorldFine")
    cl = coastlineWorldFine
    p = "+proj=merc"
  }
  
  if(colorbar){
    # setup layout for plotting
    m = rbind(c(1,1,1,1,1,1,1,1,1,1,1,2),
              c(1,1,1,1,1,1,1,1,1,1,1,2),
              c(1,1,1,1,1,1,1,1,1,1,1,2),
              c(1,1,1,1,1,1,1,1,1,1,1,2),
              c(1,1,1,1,1,1,1,1,1,1,1,2),
              c(1,1,1,1,1,1,1,1,1,1,1,2))
    
    layout(m)
    
    # configure colour scale for plotting
    pal = oce.colorsTemperature()
    zlim = range(sst, na.rm = TRUE)
    c = colormap(sst, breaks=100, zclip = T, col = pal, zlim = zlim)
  }
  
  # define unit label
  lab = 'Optimum Interpolation SST [deg C]'
  
  # plot basemap
  plot(cl, col = 'grey', projection=p,
       longitudelim=range(lon), 
       latitudelim=range(lat))
  
  # add sst layer
  mapImage(lon, lat, sst, col=oceColorsTemperature)
  
  # overlay coastline again
  mapPolygon(cl, col='grey')
  
  # add variable label
  mtext(paste0(lab),side = 3, line = 0, adj = 0, cex = 0.7)
  
  # add title
  title(paste0(time))
  
  if(colorbar){
    # add colour palette
    drawPalette(c$zlim, col=c$col, breaks=c$breaks, zlab = '', fullpage = T)
  }
}

extract_sst = function(mlat, mlon, sat){
  # extract the nearest sst at a given position
  
  # define variables
  sst = sat$sst
  lat = sat$lat
  lon = sat$lon
  time = sat$time
  
  # determine nearest lat
  ilat = which.min(abs(lat - mlat))
  
  # determine nearest lon
  ilon = which.min(abs(lon - mlon))
  
  # determine temperature
  temp = sst[ilon,ilat]
  
  # make output
  out = data.frame(date = as.Date(time),
                   slat = lat[ilat], 
                   slon = lon[ilon],
                   glat = mlat,
                   glon = mlon,
                   temperature = temp) 
  return(out)
}
