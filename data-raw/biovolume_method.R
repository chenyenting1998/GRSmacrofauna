###########################
### Adding biovolume data #
###########################
# Author: Yen-Ting Chen
# Date of creation: unknown
# Last date of modification: 2023/06/27

# Description
# Add biovolume estimation method for further biomass estimation
# See Feller and Warwick (1988) for length-width relationships,
# Hillebrand et al. (1999) for geometric estimation,
# and Benoist et al., (2020) for generalized volumetric method.
#
# Reference (reference style needs to be revised):
# Feller RJ, Warwick RM (1988) Energetics. In: Introduction to the study  of meiofauna. Smithsonian Institution Press, p 181–196
# Hillebrand H, Dürselen C-D, Kirschtel D, Pollingher U, Zohary T (1999) Biovolume calculation for pelagic and benthic microalgae. Journal of Phycology 35:403–424.
# Benoist, N.M.A., Bett, B.J., Morris, K.J., Ruhl, H.A., 2019. A generalised volumetric method to estimate the biomass of photographically surveyed benthic megafauna. Progress in Oceanography 178, 102188. https://doi.org/10.1016/j.pocean.2019.102188

################
# Load packages
################
library(readxl)
library(dplyr)
library(usethis)
library(data.table)
library(devtools)
library(testthat)
library(knitr)
library(roxygen2)
load_all()

biovolume_type <- read_xlsx("data-raw/biovolume_type.xlsx")

use_data(biovolume_type, overwrite = TRUE)
