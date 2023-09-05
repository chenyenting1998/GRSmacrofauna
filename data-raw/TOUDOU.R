#################################
### TOU and DOU data cleaning ###
#################################
# Author: Yen-Ting Chen
# Date of creation: unknown
# Last date of modification: 2023/06/28

##############
# Description
##############
# Selecting tou and dou

###################
# Loading packages
###################
library(readxl)
library(dplyr)

# dev packages
library(devtools)
library(ggplot2)
library(usethat)
library(knitr)
library(roxygen2)
load_all()

###################
# Set up functions
###################
clean_data <- function(data){
  data_cleaned <-
    data %>%
    filter(Cruise %in% c("OR1_1219", "OR1_1242")) %>%
    filter(!Station %in% c("GC1", "GS1")) %>%
    mutate(Cruise = gsub("_", "-", Cruise)) %>%
    mutate(Deployment = as.numeric(Deployment)) %>%
    mutate(Tube = as.numeric(Tube))
  return(data_cleaned)
}

###############
# 1. Load data
###############
tou_raw <- read.csv("data-raw/GPSC_tou.csv")
dou_raw <- read.csv("data-raw/GPSC_dou.csv")

######################
# 2. Process TOU data
######################
# change column name and standardize units
tou <-
  clean_data(tou_raw) %>%
  # changing column names and values of DO flux
  mutate(Habitat = "Shelf") %>%
  mutate(Incub_temperature = Temperature) %>%
  mutate(Incub_TOU = - DO_flux) %>%
  mutate(In_situ_temperature = In_situ_temperature) %>%
  mutate(In_situ_TOU = - In_situ_DO_flux) %>%
  select(Cruise, Habitat, Station, Date, Deployment, Tube,
         Incub_temperature,
         Incub_TOU,
         In_situ_temperature,
         In_situ_TOU)

# just some figures
# incub TOU
ggplot(tou_raw[tou_raw$Cruise %in% c("OR1_1219", "OR1_1242"),])+
  geom_point(aes(x = Temperature, y = - DO_flux, color = Cruise))+
  theme_bw()

ggplot(tou_raw[tou_raw$Cruise %in% c("OR1_1219", "OR1_1242"),])+
  geom_point(aes(x = Depth, y = - DO_flux, color = Cruise))+
  theme_bw()

# in situ TOU
ggplot(tou_raw[tou_raw$Cruise %in% c("OR1_1219", "OR1_1242"),])+
  geom_point(aes(x = In_situ_temperature, y = - In_situ_DO_flux, color = Cruise))+
  theme_bw()

ggplot(tou_raw[tou_raw$Cruise %in% c("OR1_1219", "OR1_1242"),])+
  geom_point(aes(x = Depth, y = - In_situ_DO_flux, color = Cruise))+
  theme_bw()

######################
# 3. Process DOU data
######################
# change column name and standardize units
dou <-
  clean_data(dou_raw) %>%
  # change column name
  mutate(Incub_temperature = Temperature) %>%
  # change DOU unit
  mutate(Incub_DOU = - Integrated_Prod / 1000000 * 10000 * 60 * 60 * 24) %>%
  mutate(In_situ_DOU = - In_situ_Integrated_Prod / 1000000 * 10000 * 60 * 60 * 24) %>%
  #                                                mmol      m-2     day-1
  # change OPD unit
  mutate(OPD = OPD / 10000) %>%  # um to cm
  select(Cruise, Habitat, Station, Deployment, Tube, Channel,
         Incub_temperature, Incub_DOU,
         In_situ_temperature, In_situ_DOU,
         OPD)

dou_averaged <-
  dou %>%
  group_by(Cruise, Habitat, Station, Deployment, Tube) %>%
  # taking the average of temperature is just suppress an error
  # there is only one temperature probe
  summarise(Incub_temperature = mean(Incub_temperature),
            Incub_DOU = mean(Incub_DOU),
            In_situ_temperature = mean(In_situ_temperature),
            In_situ_DOU = mean(In_situ_DOU),
            OPD = mean(OPD))

############
# 4. Output
############
use_data(tou, overwrite = TRUE)
use_data(dou, overwrite = TRUE)
