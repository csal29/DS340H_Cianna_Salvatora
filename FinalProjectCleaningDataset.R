#load libraries
library(readxl)
library(dplyr)

#read in dataset
df <- read_excel(file.choose(), col_names = TRUE)

#rename columns because they read in weird
colnames(df) <- c("Number", "Name", "Latitude", "Longitude", "Seasonal_Status", "Municipality", "Total_Docks", "Station_ID")

#remove first row because it column headings were read in as data
df <- df[-1,]

#make sure data types correct
df$Latitude <- as.numeric(df$Latitude)
df$Longitude <- as.numeric(df$Longitude)
df$Total_Docks <- as.numeric(df$Total_Docks)

#replace 'No ID pre-March 2023' with NA in Station_ID
df$Station_ID <- ifelse(df$Station_ID == "No ID pre-March 2023", NA, as.numeric(df$Station_ID))

#save cleaned dataset
write.csv(df, "~/Desktop/Cleaned_Bluebikes_Stations.csv", row.names = FALSE)
