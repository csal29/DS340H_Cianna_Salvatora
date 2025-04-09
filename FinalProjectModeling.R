#loading packages
library(sf)
library(tidyverse)
library(ggplot2)
library(dplyr)
library(car)  
library(lmtest)
library(MASS)

#read full bike data
bikedata <- read_csv(file.choose())#full_bike_data.csv

#convert categorical variable (Largest Age Group)
bikedata <- bikedata %>%
  mutate(`Largest Age Group` = as.factor(`Largest Age Group`))




#first-order model

#full first order model
fullmodel <- lm(Total_Docks ~ bikedata$`2023POP` + bikedata$`Largest Age Group` + Distance_to_Nearest_College_km + Distance_to_Nearest_MBTA_km, 
                        data = bikedata)

# View model summary
summary(fullmodel)


#Compare Alternative Models
#Stepwise AIC model selection
bestModel <- stepAIC(fullmodel, direction = "both")

# Display summary of the best model
summary(bestModel)

#Check Model Assumptions
#Scatterplot (Linearity)
ggplot(bikedata, aes(x = Distance_to_Nearest_MBTA_km, y = Total_Docks, color = `Largest Age Group`)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE, color = "black") +
  labs(title = "Scatterplot of Total Docks vs. Distance to Nearest MBTA",
       x = "Distance to Nearest MBTA (km)",
       y = "Total Docks") +
  theme_minimal()

#Residual vs Fitted Plot (Equal Variance)
plot(bestModel$fitted.values, residuals(bestModel),
     main = "Residuals vs Fitted",
     xlab = "Fitted Values",
     ylab = "Residuals")
abline(h = 0, col = "red")

#Q-Q Plot (Normality of Residuals)
qqnorm(residuals(bestModel))
qqline(residuals(bestModel), col = "red")





#seems to be some violation of constant variance assumption, so applying a Box-Cox transformation
boxCox(bestModel)




lambda1 <- -1
# Create a transformed response variable:
bikedata$Transformed_Docks1 <- (bikedata$Total_Docks^lambda1 - 1) / lambda1

# Fit the model again using the transformed response
transModel1 <- lm(Transformed_Docks1 ~ `Largest Age Group` + Distance_to_Nearest_MBTA_km, data = bikedata)
summary(transModel1)

#Check Model Assumptions
#Scatterplot (Linearity)
ggplot(bikedata, aes(x = Distance_to_Nearest_MBTA_km, y = Transformed_Docks1, color = `Largest Age Group`)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE, color = "black") +
  labs(title = "Scatterplot of Total Docks vs. Distance to Nearest MBTA",
       x = "Distance to Nearest MBTA (km)",
       y = "Transformed Docks") +
  theme_minimal()

#Residual vs Fitted Plot (Equal Variance)
plot(transModel1$fitted.values, residuals(transModel),
     main = "Residuals vs Fitted",
     xlab = "Fitted Values",
     ylab = "Residuals")
abline(h = 0, col = "red")

#Q-Q Plot (Normality of Residuals)
qqnorm(residuals(transModel1))
qqline(residuals(transModel1), col = "red")










#second-order model

#interaction model
#using best model from above
interactionModel <- lm(Transformed_Docks1 ~ `Largest Age Group` * Distance_to_Nearest_MBTA_km,
                       data = bikedata)
summary(interactionModel)

#wanted to investigate age group and distance to nearest College interaction
interactionModel2 <- lm(Transformed_Docks1 ~ `Largest Age Group` * Distance_to_Nearest_College_km, data = bikedata)
summary(interactionModel2)


#doing a stepwise interaction with the OG full model
fullInteraction <- lm(Transformed_Docks1 ~ (`2023POP` +`Largest Age Group` + Distance_to_Nearest_MBTA_km + Distance_to_Nearest_College_km)^2, 
                       data = bikedata)
stepwiseInteractionModel <- stepAIC(fullInteraction, direction = "both")
summary(stepwiseInteractionModel)


#plots for stepwise "significant" interactions
#Age Group and distance to nearest MBTA
ggplot(bikedata, aes(x = Distance_to_Nearest_MBTA_km,
                     y = Transformed_Docks1,
                     color = `Largest Age Group`)) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = "lm", se = FALSE) +
  labs(title = "Interaction: Age Group × MBTA Distance",
       x = "Distance to Nearest MBTA (km)",
       y = "Transformed Docks") +
  theme_minimal()

#distance MBTA and distance college
ggplot(bikedata, aes(x = Distance_to_Nearest_MBTA_km,
                     y = Transformed_Docks1,
                     color = Distance_to_Nearest_College_km)) +
  geom_point(alpha = 0.6) +
  scale_color_viridis_c() +
  labs(title = "Interaction: MBTA × College Distance",
       x = "Distance to MBTA (km)",
       y = "Transformed Docks",
       color = "College Distance (km)") +
  theme_minimal()



