####################################################
### macrofauna biovolume and biomass calculation ###
####################################################

# Description
# calculate the biovolume and biomass of each individuals

library(readxl)
library(dplyr)
library(usethis)
library(data.table)
library(devtools)
library(testthat)
library(knitr)
library(roxygen2)
load_all()
document()

# estimate biovolume and biomass
size <-
  OR1_1219_macro_mea %>%
  full_join(OR1_1242_macro_mea) %>%
  mutate(Type = NULL) %>%
  assign_method(method_file = biovolume_method) %>%
  calculate_biovolume() %>%
  calculate_ophiuroid_size(ophiuroid_method = "all_arms",
                           grouping_variables = c("Cruise", "Habitat",
                                                  "Station", "Deployment", 'Tube', "Section"))

# output data
use_data(size, overwrite = TRUE)
document()
