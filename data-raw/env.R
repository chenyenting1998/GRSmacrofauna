########################################
### bottom environment data cleaning ###
########################################
# Author: Yen-Ting Chen
# Date of creation: unknown
# Last date of modification: 2023/06/28

##############
# Description
##############
# Allocating sediment geochemical data, bottom CTD data, and distance to river.

################
# Load packages
################
library(readxl)
library(dplyr)
library(geosphere)

# dev packages
library(usethis)
library(devtools)
library(testthat)
library(knitr)
library(roxygen2)
load_all() # load GRSmacrofauna

############################
# 1. Load bottom water data
############################
# extract ctd bottom water data
bw <-
  ctd %>%
  group_by(Cruise, Station) %>%
  filter(Pressure %in% max(Pressure))

########################
# 2. load sediment data
########################
sed <-
  read_xlsx("data-raw/PR_GPR_Sediment_2021.06.20_ys.xlsx",
            col_types = c(rep("text", 4), rep("numeric", 16)))

# Cruise _ to -
sed$Cruise <- gsub("_", "-", sed$Cruise)
# subset GRS data
sed <- sed %>% filter(Station %in% paste0("S", 1:7))

# omitting section, deployment, WW, DW, TNd15, chla, pheo
col_sel <- c("Cruise", "Station",
             "d50", "Clay", "Silt", "Sand",
             "TOC", "TN", "CN", "TOCd13", "Chla*", "WC", "Porosity")
sed <- sed %>% select(all_of(col_sel))

# porosity into %
sed$Porosity <- sed$Porosity * 100

# rename columns
colnames(sed)[colnames(sed) == "Chla*"] <- "Chla" # rename chlorphyll a
colnames(sed)[colnames(sed) == "TOCd13"] <- "delta13C" # rename delta13C
colnames(sed)[colnames(sed) == "d50"] <- "D50" # rename D50

# combine bottom water and sediment data
env <- full_join(bw, sed)

###############################
# 3. Change pressure to  depth
###############################
depth <- read_xlsx("data-raw/depth.xlsx")
grs_depth <- depth %>% filter(Station %in% paste0("S", 1:7))
grs_depth$Cruise <- gsub("_", "-", grs_depth$Cruise)

# combine env with depth
env <- full_join(env, grs_depth)
env$Pressure <- NULL

#################################
# 4. Add distance to river mouth
#################################
# calculate distance to river mouth
GRM <- c(120.423960, 22.470504) # gaoping rivermouth
env$DRM <- distm(x = env[,c("Longitude", "Latitude")], y = GRM, fun = distGeo)/1000

# relocate columns
env
env <- env[,c("Cruise", "Habitat", "Station", "Date", "Latitude", "Longitude", "Depth", "DRM",
       "Temperature", "Salinity", "SigmaTheta", "Density", "Oxygen", "Fluorescence", "Transmission",
       "Sand", "Silt", "Clay", "D50",
       "TOC", "TN", "CN", "delta13C", "Chla", "WC", "Porosity")]
View(env)
# output
use_data(env, overwrite = TRUE)
