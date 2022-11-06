########################################
### bottom environment data cleaning ###
########################################

# Description
# Cleaning bottom environment data into downcasts and bottom water

library(readxl)
library(dplyr)
library(data.table)
library(geosphere)
load_all()

# extract ctd bottom water data
bw <- GRS_ctd[GRS_ctd[, Pressure == max(Pressure), by = .(Cruise, Station)]$V1]

# load sediment data
sed <- read_xlsx("data-raw/PR_GPR_Sediment_2021.06.20_ys.xlsx",
                 col_types = c(rep("text", 4), rep("numeric", 16))) %>%
  setDT

# Cruise _ to -
sed$Cruise <- gsub("_", "-", sed$Cruise)

# subset GRS data
sed <- sed[Station %in% paste0("S", 1:7), ]

# removing section, deployment, WW, DW, TNd15, chla, pheo
col_sel <- c("Cruise", "Station", "d50", "Clay", "Silt", "Sand", "CN", "TOC", "TN", "WC", "TOCd13", "Chla*", "Porosity")
sed <- sed[,..col_sel]

# porosity into %
sed$Porosity <- sed$Porosity * 100
# Chla* to Chla
colnames(sed)[colnames(sed) == "Chla*"] <- "Chla"

# combine bottom water and sediment data
env <- merge(bw, sed, by = c("Cruise", "Station"))

# read depth
depth <- read_xlsx("data-raw/depth.xlsx") %>% setDT()
grs_depth <- depth[Station %in% paste0("S", 1:7), ]
grs_depth$Cruise <- gsub("_", "-", grs_depth$Cruise)

# combine env with depth
env <- merge(env, grs_depth, by = c("Cruise", "Station"))
env$Pressure <- NULL

# calculate distance to river mouth
GRM <- c(120.423960, 22.470504) # gaoping rivermouth
env$DRM <- distm(x = env[,c("Longitude", "Latitude")], y = GRM, fun = distGeo)/1000

# relocate columns
setcolorder(env, c("Cruise", "Station", "Date", "Latitude", "Longitude", "Depth", "DRM",
                   "Temperature", "Salinity", "Sigma-Theta", "Density", "Oxygen", "Fluorescence", "Transmission",
                   "d50", "Clay", "Silt", "Sand", "CN", "TOC", "TN", "WC", "TOCd13", "Chla", "Porosity"))

# output
use_data(env, overwrite = TRUE)
