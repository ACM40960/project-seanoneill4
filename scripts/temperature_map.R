##
## This script creates measurement location and yearly anomaly maps.
##

library(ggmap)

# import data
data <- read.csv(file='../data/processed/temperature_PRO.csv', sep = ",", header=TRUE)

# load map data and match available coordinates
map_data <- map_data("world")
map_data <- subset(map_data, long>min(data$lon) & long<max(data$lon) & lat>min(data$lat) & lat<max(data$lon))

############################
## measurement location map
############################

# create plot
temp_map <- ggplot() +
    theme_void() +
    geom_tile(data=data, aes(x=lon, y=lat), color="black", alpha=0.1) +
    geom_point(data=map_data, aes(x=long, y=lat), fill="black", 
               shape=15, size=0.225) +
    ggtitle("Distribution of temperature measurements") +
    theme(plot.title=element_text(hjust=0.5, size=18), 
          panel.background = element_rect(fill='white', colour='white'),
          plot.background = element_rect(fill="white")) 

temp_map

# save plot
ggsave(filename="../data/images/temp_grid.png", plot=temp_map, dpi=300,
       width=10, height=10/2) # equirectangular projection 2:1



###############
## anomaly map
###############

# plotting function
plot_anom <- function(year){
    ##
    ## Plot the mean global temperature anomaly on a world map.
    ##
    ## Parameters
    ## ----------
    ## year : year to be plotted
    ##
    ## Returns
    ## -------
    ## anom_map : ggplot2 object
    ##
    
    # create year index
    index <- paste("X", year, sep="")
    # create data subset
    data_tmp <- data[c("lat", "lon", "temp"=index)] 
    # rename temperature column
    names(data_tmp)[3] <- "temp"
    
    # create plot
    anom_map <- ggplot() +
        theme_void() +
        geom_tile(data=data_tmp, aes(x=lon, y=lat, fill=temp), alpha=1.0) +
        scale_fill_gradient2(low = "dodgerblue1",
                             mid = "white", 
                             high = "firebrick1",
                             name = "°C") +
        geom_point(data=map_data, aes(x=long, y=lat), fill="black", 
                   shape=15, size=0.225) +
        ggtitle(paste("Mean global temperature anomaly", year, "(1951-1980 baseline)")) +
        theme(plot.title=element_text(hjust=0.5, size=18), 
              panel.background = element_rect(fill='white', colour='white'),
              plot.background = element_rect(fill="white"),
              legend.position = c(0.978, 0.5)) 
    
    return(anom_map)
}

# create plot
anom_map <- plot_anom(2022)

anom_map

# save plot
ggsave(filename="../data/images/anomaly2022.png", plot=anom_map, dpi=300,
       width=10, height=10/2) # equirectangular projection 2:1
