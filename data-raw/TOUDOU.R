#################################
### TOU and DOU data cleaning ###
#################################

# Description
# Selecting TOU and DOU

library(readxl)
library(dplyr)
library(devtools)
library(usethat)
library(knitr)
library(roxygen2)

load_all()

# read data
DOU <- read.csv("data-raw/GPSC_DOU.csv")
TOU <- read.csv("data-raw/GPSC_TOU.csv")

# TOU
TOU$Cruise <- gsub("_", "-", TOU$Cruise)
TOU <-
  TOU %>%
  filter(Cruise %in% c("OR1-1219", "OR1-1242")) %>%
  select(Cruise, Station, Deployment, Tube,
         DO_flux, Temperature, In_situ_temperature, In_situ_DO_flux)


# DOU
DOU$Cruise <- gsub("_", "-", DOU$Cruise)
DOU <-
  DOU %>%
  filter(Cruise %in% c("OR1-1219", "OR1-1242")) %>%
  select(Cruise, Station, Deployment, Tube,
         OPD, Temperature, In_situ_temperature, In_situ_Integrated_Prod)

# output data
use_data(TOU, overwrite = TRUE)
use_data(DOU, overwrite = TRUE)
