# ## Motivation
# There are many software solutions that will allow you to make a map. Some of them are free and open source (_e.g._ [GRASS](grass.osgeo.org/)) or not (_e.g._ [ArcGIS](http://www.arcgis.com/features/)). The argument between R and something that isn't free is pretty self explanatory, but why would we want to do our GIS tasks in R over something else like GRASS that was designed for this purpose? My usual answer to that is that I prefer a nice workflow all in R, I like the continuity. I also like leveraging my R programming know-how (e.g. data manipulation, loops, etc) to do complex and/or repeated operations that might take me longer to click through or learn how to automate in some other program.
# Really, you just need to find the right tool for the job, sometimes that will be R, other times it will be a dedicated GIS program. Also, R and GRASS can [interact](http://grasswiki.osgeo.org/wiki/R_statistics) providing an intermediate solution. All that being said, it helps to know what R can do when you're choosing your tool.

# ## Load the required packages
library(maptools)
library(rgdal)

# ## Getting a base map
# There are a few ways to get this type of thing in R, I'll cover many of these in a future lesson, for now let's just use a simple world map from the maptools package:

    data(wrld_simpl)
    

# Let's plot that to see what we have
    
    plot(wrld_simpl)

# Or we can 'zoom in' on a particular spot if we provide limits
    
    xlim=c(-130,-60)
    ylim=c(45,80)
    plot(wrld_simpl,xlim=xlim,ylim=ylim)

# We can also give it some color
    
    plot(wrld_simpl,xlim=xlim,ylim=ylim,col='olivedrab3',bg='lightblue')
    
# I know, the map projection is not awesome, we're going to cover that in another future lesson. 
    
# ## Exporting and importing
# Now that we know how to get a super basic map in R, let's look at how we can export and import data. This will write an ArcGIS compatible shapefile, `writeOGR()` will actually write to many different formats you just need to find the correct `driver`
    
    writeOGR(wrld_simpl,dsn=getwd(), layer = "world_test", driver = "ESRI Shapefile")
    
# Now we could open `world_test.shp` in ArcGIS, but we can also import shapefiles back into R, let's use that same file
    
    world_shp <- readOGR(dsn = getwd(),layer = "world_test")
    plot(world_shp)
    
# ## Spatial data types in R
# ### Vector based (points, lines, and polygons)
# creating spatial data from scratch in R seems a little convoluted to me, but once you understand the pattern, it gets easier

# #### SpatialPointsDataFrame
# let's plot points on Simon Fraser University and University of Toronto
    coords <- matrix(c(-122.92,-79.4, 49.277,43.66),ncol=2)
    coords <- coordinates(coords)
    spoints <- SpatialPoints(coords)
    df <- data.frame(location=c("SFU","UofT"))
    spointsdf <- SpatialPointsDataFrame(spoints,df)
    plot(spointsdf,add=T,col=c('red','blue'),pch=16)
    
# #### SpatialLinesDataFrame
# let's plot the borders of the province of Saskatchewan because they're easy to draw (but not to spell!)
    coords <- matrix(c(-110,-102,-102,-110,-110,60,60,49,49,60),ncol=2)
    l <- Line(coords)
    ls <- Lines(list(l),ID="1")
    sls <- SpatialLines(list(ls))
    df <- data.frame(province="Saskatchewan")
    sldf <- SpatialLinesDataFrame(sls,df)
    plot(sldf,add=T,col='black') 
  
# #### SpatialPolygonsDataFrame
# let's plot the province of Saskatchewan because it's easy to draw (but not to spell!)
    coords <- matrix(c(-110,-102,-102,-110,-110,60,60,49,49,60),ncol=2)
    p <- Polygon(coords)
    ps <- Polygons(list(p),ID="1")
    sps <- SpatialPolygons(list(ps))
    df <- data.frame(province="Saskatchewan")
    spdf <- SpatialPolygonsDataFrame(sps,df)
    plot(spdf,add=T,col='red')  
    
    http://pakillo.github.io/R-GIS-tutorial/#plot
        http://www.milanor.net/blog/?p=594
    