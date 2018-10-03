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