#################################
### tou and dou data cleaning ###
#################################

# Description
# Selecting tou and dou

library(readxl)
library(dplyr)
library(devtools)
library(usethat)
library(knitr)
library(roxygen2)

load_all()

# read data
dou <- read.csv("data-raw/GPSC_dou.csv")
tou <- read.csv("data-raw/GPSC_tou.csv")

# tou
tou$Cruise <- gsub("_", "-", tou$Cruise)
tou <-
  tou %>%
  filter(Cruise %in% c("OR1-1219", "OR1-1242")) %>%
  select(Cruise, Station, Deployment, Tube,
         DO_flux, Temperature, In_situ_temperature, In_situ_DO_flux)


# dou
dou$Cruise <- gsub("_", "-", dou$Cruise)
dou <-
  dou %>%
  filter(Cruise %in% c("OR1-1219", "OR1-1242")) %>%
  select(Cruise, Station, Deployment, Tube,
         OPD, Temperature, In_situ_temperature, In_situ_Integrated_Prod)

# output data
use_data(tou, overwrite = TRUE)
use_data(dou, overwrite = TRUE)
