##########################
### Create coarse taxa ###
##########################

# Description
# Create a data.frame for matching various taxa to a higher taxa level.
# Mainly used for plotting and/or visualization.

library(readxl)
coarse_taxa <- read_xlsx("data-raw/coarse_taxa.xlsx")
usethis::use_data(coarse_taxa, overwrite = TRUE)


devtools::load_all()
devtools::document()
