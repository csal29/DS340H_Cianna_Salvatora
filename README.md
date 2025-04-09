# DS340H_Cianna_Salvatora
Data analysis project to understand the factors that influence the number of total bike docks at a given Blue Bike station.

## Navigating the Repository
### Folders
**Original_Datasets:** Contains the original datasets that were downloaded from the Bluebike website, MassGIS (both college and MBTA data), and the MA Dept. of Revenue.

**posterVisualizations:** Contains each of the visualizations from the poster, to get a closer look.


### Files
#### Datasets
<par>**Cleaned_Bluebikes_Stations.csv:** Cleaned dataset only containing bluebike station data (produced by FinalProjectCleaningDataset.R & reads into FinalProjectDataAdjustments.R)<par/>
<par>**full_bike_data.csv:** Merged dataset with all the info (produced by FinalProjectDataAdjustments.R & reads into FinalProjectModeling.R and FinalProjectVisualizations.R)<par/>

#### R scripts
<par>**FinalProjectCleaningDataset.R:** Cleans the initial datset downloaded from the bluebike website, and produces Cleaned_Bluebikes_Stations.csv<par/>
<par>**FinalProjectDataAdjustments.R:** Merges all the info from the datasets, and produces full_bike_data.csv<par/>
<par>**FinalProjectModeling.R:** Contains code for all the modeling and data analysis, as well as the visualizations for validity checks and plots that demonstrate models<par/>
<par>**FinalProjectVisualizations.R:** Creates the visualization for an overview of dock availability based on area<par/>


