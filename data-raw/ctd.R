#########################
### CTD data cleaning ###
#########################

# Description
# Subsetting CTD data into downcasts and bottom water

library(readxl)
library(dplyr)
library(data.table)

# import ctd data ####
all_ctd_raw =
  read_xlsx("data-raw/GPSC_CTD_2021.03.19.xlsx") %>%
  setDT()

# subset ctd data ####
grs_cruise = c("OR1_1242", "OR1_1219")
grs_station = paste0("S", c(1,2,3,4,5,6,7))
grs_ctd_raw = all_ctd_raw[Cruise %in% grs_cruise & Station %in% grs_station]

# change cruise underline to dash
grs_ctd_raw$Cruise <- gsub("_", "-", grs_ctd_raw$Cruise)

# select, rename, and calculate columns ####
grs_ctd_raw = grs_ctd_raw[,.(Cruise,
                             Station,
                             Date = date,
                             Latitude,
                             Longitude,
                             Pressure = pressure,
                             Temperature = (temperature_T1 + temperature_T2) * 0.5,
                             Salinity = (salinity_T1C1 + salinity_T2C2) * 0.5,
                             `Sigma-Theta` = (density_T1C1...11 + density_T2C2...12) * 0.5,
                             Density = (density_T1C1...13 + density_T2C2...14) * 0.5,
                             Oxygen = Oxygen,
                             Fluorescence = fluorometer,
                             Transmission = transmissometer)]

# subset downcast ####
ctd = grs_ctd_raw[,.SD[1:which.max(Pressure)], by = .(Cruise, Station)]

use_data(ctd, overwrite = TRUE)
