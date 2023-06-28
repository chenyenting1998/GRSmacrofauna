#########################
### CTD data cleaning ###
#########################
# Author: Yen-Ting Chen
# Date of creation: Unknown
# Last date of modification: 2023/06/28

##############
# Description
##############
# Subsetting CTD data into downcasts and bottom water

################
# Load packages
################
library(readxl)
library(dplyr)

###############
# 1. Load data
###############
# import ctd data ####
all_ctd_raw <- read_xlsx("data-raw/GPSC_CTD_2021.03.19.xlsx")

# subset ctd data ####
grs_cruise <- c("OR1_1242", "OR1_1219")
grs_station <- paste0("S", 1:9)
grs_ctd_raw <-
  all_ctd_raw %>%
  filter(Cruise %in% grs_cruise & Station %in% grs_station)

# change cruise underline to dash
grs_ctd_raw$Cruise <- gsub("_", "-", grs_ctd_raw$Cruise)

###########################################
# 2. select, rename, and calculate columns
###########################################
grs_ctd_raw_cleaned <-
  grs_ctd_raw %>%
  # renaming columns
  mutate(Date = date,
         Pressure = pressure,
         Fluorescence = fluorometer,
         Transmission = transmissometer) %>%
  # calculate averages of duo-sensors
  mutate(Temperature = (temperature_T1 + temperature_T2) / 2,
         Salinity = (salinity_T1C1 + salinity_T2C2) / 2,
         SigmaTheta = (density_T1C1...11 + density_T2C2...12) / 2,
         Density = (density_T1C1...13 + density_T2C2...14) / 2) %>%
  # subset columns
  select(Cruise, Station, Date, Latitude, Longitude,
         Pressure, Temperature, Salinity, SigmaTheta,
         Density, Oxygen, Fluorescence, Transmission)

#####################
# 3. subset downcast
#####################
ctd <-
  grs_ctd_raw_cleaned %>%
  # lag() returns the value of the previous cell
  # the `default` option makes sure that there will be no missing values
  filter(Pressure > lag(Pressure, default = Pressure[1]))

############
# 4. output
############
use_data(ctd, overwrite = TRUE)
