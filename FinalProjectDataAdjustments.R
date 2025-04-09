install.packages("sf")

#loading packages
library(sf)
library(dplyr)
library(ggplot2)
library(tidyr)
library(stringr)
library(readxl)

#reading in datasets
bikeData <- read.csv(file.choose())
collegeDataWithCoordiantes <- st_read(file.choose()) #colleges in all of Massachusetts
MBTAData <- read.csv(file.choose())
populationData <- read_excel(file.choose()) #with largest age group info



#everything for adding college/university data to the bike data
#extract coordinates
coords <- st_coordinates(collegeDataWithCoordiantes)

#add longitude and latitude back into main dataset
collegeDataWithCoordiantes$Longitude <- coords[,1]
collegeDataWithCoordiantes$Latitude <- coords[,2]

#filtering out colleges outside of boston area
#extract range from bluebikes data
latRange <- range(bikeData$Latitude, na.rm = TRUE)
lonRange <- range(bikeData$Longitude, na.rm = TRUE)

#filter colleges within bounding box
collegesBostonArea <- collegeDataWithCoordiantes %>%
  filter(
    Latitude >= latRange[1],
    Latitude <= latRange[2],
    Longitude >= lonRange[1],
    Longitude <= lonRange[2]
  )

#make sure both datasets are spatial objects
bikeSpatial <- st_as_sf(bikeData, coords = c("Longitude", "Latitude"), crs = 4326)
collegesSpatial <- collegesBostonArea 

#compute matrix of distances from each bike station to every college
distMatrix <- st_distance(bikeSpatial, collegesSpatial)

#find the index of the nearest college for each bluebike station
nearestCollegeIndex <- apply(distMatrix, 1, which.min)

#find min distance for each bike station
minDistanceCollege <- apply(distMatrix, 1, min)

#extract name of nearest college
nearestCollegeNames <- collegesSpatial$COLLEGE[nearestCollegeIndex]  

#add columns to bikeSpatial dataset
bikeSpatial <- bikeSpatial %>%
  mutate(
    Distance_to_Nearest_College = as.numeric(minDistanceCollege),
    Distance_to_Nearest_College_km = as.numeric(minDistanceCollege) / 1000,
    Nearest_College = nearestCollegeNames
  )



#everything for adding MBTA data to bike data
#make dataset a spatial object
MBTASpatial <- MBTAData %>%
  st_as_sf(wkt = "shape", crs = 4326)

#compute matrix of distances from each bike station to each MBTA station
distMatrixMBTA <- st_distance(bikeSpatial, MBTASpatial)

#find index of nearest MBTA station for each bike station
nearestMBTAIndex <- apply(distMatrixMBTA, 1, which.min)

#find minimum distance to from bike station to MBTA station
minDistanceMBTA <- apply(distMatrixMBTA, 1, min)

#extract name of station
nearestMBTAStations <- MBTASpatial$station[nearestMBTAIndex]

#add columns to bikeSpatial dataset
bikeSpatial <- bikeSpatial %>%
  mutate(
    Distance_to_Nearest_MBTA = as.numeric(minDistanceMBTA),
    Distance_to_Nearest_MBTA_km = as.numeric(minDistanceMBTA) / 1000,
    Nearest_Station = nearestMBTAStations
  )



#everything for adding population data to bike data
#add columns from population data to bike data based on municipality
bikeSpatial <- bikeSpatial %>%
  left_join(populationData, by = "Municipality")
#remove "DOR Code" column because i don't need it
bikeSpatial <- bikeSpatial %>% select(-'DOR Code')

#the largest age group info was added manually




#save cleaned dataset
write.csv(bikeSpatial, "~/Desktop/Capstone/Capstone final project/full_bike_data.csv", row.names = FALSE)







