#############################
### Macrofauna data cleaning
#############################
# Author: Yen-Ting Chen
# Date of creation: unknown
# Last date of modification: 2023/06/25

##############
# Description
##############
# Cleaning macrofauna data by merging data from Yen-Ting Chen and Yen-Li Liu

################
# Load packages
################
# dev packages
library(usethis)
library(devtools)
library(testthat)
library(knitr)
library(roxygen2)
load_all() # load GRSmacrofauna

library(readxl)
library(dplyr)


#################
# load functions
#################

# capwords (originated from toupper example)
# capitalizes the first letter of a character
capwords <- function(s, strict = FALSE) {
  cap <- function(s)
    paste(toupper(substring(s, 1, 1)),
          {
            s <- substring(s, 2)
            if (strict)
              tolower(s)
            else
              s
          },
          sep = "", collapse = " ")
  sapply(strsplit(s, split = " "), cap, USE.NAMES = !is.null(names(s)))
}

# add habitat (only use this function in this script)
# add canyon/slope/shelf regarding station name
add_habitat <- function(data) {
  data$Habitat <-
    if_else(data$Station %in% "GC1", "Canyon", data$Habitat)
  data$Habitat <-
    if_else(data$Station %in% "GS1", "Slope", data$Habitat)
  data$Habitat <-
    if_else(data$Station %in% paste0("S", 1:10), "Shelf", data$Habitat)
  return(data)
}

# clean_data (only use this function in this script)
# a bundle function for data cleaning
clean_data <- function(data) {
  data_cleaned <-
    data %>%
    mutate(Cruise = gsub("_", "-", Cruise)) %>% # change _ in Cruise to -
    mutate(Section = "0-10") %>% # add section
    mutate(Type = capwords(Type)) %>% # capitalize first letter of type
    mutate(Habitat = as.character(Habitat)) %>% # convert class to character
    add_habitat() # add habitat

  return(data_cleaned)
}

#############################################################
# 1. Read OR1_1219 data and exclude polychaete measurements
#############################################################
or1_1219_macro_raw <-
  read_xlsx("data-raw/OR1_1219_macro_size_final.xlsx",
            col_types = c(rep("guess", 7), rep("text", 2), rep("guess", 8)))

# there are erroneous measurements in OR1-1219 S7-2-3
# remove S7-2-3 data from the original data.frame
or1_1219_macro_raw <-
  or1_1219_macro_raw %>%
  filter(!(Station == "S7" & Deployment == 2 & Tube == 3))

# import corrected S7-2-3 data
S7_2_3 <-
  read_xlsx("data-raw/OR1-1219_S7-2-3.xlsx",
            col_types = c(rep("guess", 7), rep("text", 2), rep("guess", 8)))

# merge S7-2-3 with the old measurement data
or1_1219_macro_raw <- full_join(or1_1219_macro_raw, S7_2_3)

# data cleaning
or1_1219_macro_raw <-
  or1_1219_macro_raw %>%
  assign_type() %>%
  clean_data() %>%
  filter(Taxon != "Polychaeta")

#############################################################
# 2. Read OR1_1242 data and exclude polychaete measurements
#############################################################
or1_1242_macro_raw <-
  read_xlsx("data-raw/OR1_1242_macro_size_final.xlsx",
            col_types = c(rep("guess", 7), rep("text", 2), rep("guess", 8)))

# Change column entries
# Taxon of one unknown from "Sea pen" to "Unknown"
or1_1242_macro_raw[or1_1242_macro_raw$Taxon == "Sea pen", "Taxon"] <- "Unknown"
# Condition of two unknowns from "X" to "F"
or1_1242_macro_raw[or1_1242_macro_raw$Condition == "x", "Condition"] <- "F"

# data cleaning
or1_1242_macro_raw <-
  or1_1242_macro_raw %>%
  assign_type() %>%
  clean_data() %>%
  filter(Taxon != "Polychaeta") # remove polychaeta

###########################################
# 3. Read OR1_1219 polychaete measurements
###########################################
# note that Mrs. Liu calculated polychaetes with two geometric shapes
# ellipsoids for sternaspids, cylinder for the rest
or1_1219_poly <-
  read_xlsx("data-raw/OR1_1219 polychaeta size.xlsx",
            col_types = c(rep("guess", 7), rep("text", 2), rep("guess", 8)))

# data cleaning
or1_1219_poly <- clean_data(or1_1219_poly)

###########################################
# 4. read or1_1242 polychaete measurements
###########################################
# note that Mrs. Liu calculated polychaetes with two geometric shapes
# ellipsoids for sternaspids, cylinder for the rest
or1_1242_poly <-
  read_xlsx("data-raw/OR1_1242_polychaeta_size.xlsx",
            col_types = c(rep("guess", 7), rep("text", 2), rep("guess", 7)))

# Change column entries
# Taxon of one unknown from "Sea pen" to "Unknown"
or1_1242_poly[or1_1242_poly$Condition == "H", "Condition"] <- "FH"

# data cleaning
or1_1242_poly <- clean_data(or1_1242_poly)

#############
# 5. Outputs
#############
# Combined raw measurements for all GRS stations
macrofauna_measurements <-
  # combining data.frames
  full_join(or1_1219_macro_raw, or1_1242_macro_raw) %>%
  full_join(or1_1219_poly) %>%
  full_join(or1_1242_poly) %>%
  # arrange rows by categorical variables
  arrange(Cruise, Station, Deployment, Tube, Taxon) %>%
  # relocate columns
  relocate(Type, .after = Condition) %>%
  relocate(C, .after = W) %>%
  mutate(Size = NULL) # delete the column 'Size'

# calculating biovolume
grouping_variables <-
  c("Cruise", "Habitat", "Station", "Deployment", "Tube", "Section")
macrofauna_biomass <-  # calculate ind. biomass
  calculate_biovolume(macrofauna_measurements) %>%
  calculate_ophiuroid_size(ophiuroid_method = "all_arms",
                           grouping_variables = grouping_variables) %>%
  # assuming 1.13 specific density (Gerlach et al., 1985)
  mutate(WM = Size * 1.13) %>%
  # relocate columns
  relocate(Size, .before = Note) %>%
  relocate(WM, .after = Size)

# output
use_data(macrofauna_measurements, overwrite = TRUE)
use_data(macrofauna_biomass, overwrite = TRUE)
