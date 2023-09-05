#########################
### Map data cleaning ###
#########################
# Author: Yen-Ting Chen
# Date of creation: 2023/09/05
# Last date of modification: 2023/09/05

##############
# Description
##############
# Processing bathymetric data for mapping

###################
# Loading packages
###################
library(readxl)
library(writexl)
library(dplyr)
library(tidyr)
library(usethis)
library(ncdf4)

#############
# Bathy map #
#############
# read .nc
map_nc_path <- dir(path = "data-raw/GEBCO_2020", pattern = "2020.nc", full.names = T)
map_nc <- nc_open(map_nc_path)

# extract lon. and lat.
Longitude <- ncvar_get(map_nc, "lon")
Latitude <- ncvar_get(map_nc, "lat")
Elevation <- ncvar_get(map_nc, "elevation")

# entries as elevation with each row and columns as lats and longs
map <-
  expand.grid(Longitude = Longitude,
              Latitude = Latitude) %>%
  cbind(Elevation = as.vector(Elevation))

bathy_map <- map

bathy_map <-
  bathy_map %>%
  filter(Longitude < 122 & Longitude > 108) %>%
  filter(Latitude < 25.5 & Latitude > 18)

###########
# GRS map #
###########
grs_map_name <- dir(path = "data-raw", pattern = ".xyz", full.names = T)
grs_map <- read.table(grs_map_name)
names(grs_map) <- c("Longitude", "Latitude", "Elevation")

##########
# output #
##########
use_data(bathy_map, overwrite = T)
use_data(grs_map, overwrite = T)
