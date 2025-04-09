#libraries
library(ggplot2)
library(dplyr)

#read full bike data
bikedataVis <- read_csv(file.choose())#full_bike_data.csv


#visualization for overview of dock availablity based on area
plotData <- bikedataVis %>%
  group_by(Municipality) %>%
  summarise(avg_docks = mean(Total_Docks, na.rm = TRUE)) %>%
  arrange(avg_docks)

ggplot(plotData, aes(x = avg_docks, y = reorder(Municipality, avg_docks))) +
  geom_point(color = "darkgreen", size = 3) +
  geom_segment(aes(x = 0, xend = avg_docks, y = reorder(Municipality, avg_docks), yend = reorder(Municipality, avg_docks)),
               color = "lightgreen") +
  labs(
    x = "Average Total Docks",
    y = "Municipality",
    title = "Average Bluebike Dock Count by Municipality",
    caption = "Figure 1. Summary of Station Capacity Across Municipalities"
  ) +
  theme_minimal() +
  theme(axis.text.y = element_text(size = 9))
