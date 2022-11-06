#############################
### Adding biovolume data ###
#############################

# Description
# Add biovolume estimation method for further biomass estimation
# See Feller and Warwick (1988) for length-width relationships
# and Hillebrand et al. (1999) for geometric estimation.
#
# Reference:
# Feller RJ, Warwick RM (1988) Energetics. In: Introduction to the study  of meiofauna. Smithsonian Institution Press, p 181–196
# Hillebrand H, Dürselen C-D, Kirschtel D, Pollingher U, Zohary T (1999) Biovolume calculation for pelagic and benthic microalgae. Journal of Phycology 35:403–424.

library(readxl)
library(dplyr)
library(usethis)
library(data.table)
library(devtools)
library(testthat)
library(knitr)
library(roxygen2)
load_all()

biovolume_method <- read_xlsx("data-raw/biovolume_method.xlsx")

use_data(biovolume_method, overwrite = TRUE)
