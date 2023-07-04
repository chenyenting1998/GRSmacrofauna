# GRSmacrofauna

# Description
This is a data package containing biological, environmental, and biogeochemical data collected in the Gaoping River-shelf sediments. A set of self-defined R functions are also included in this package.

Data includes:
 - `macrofauna_measurments`: Individual macrofauna taxa and measurments
 - `macrofauna_biomass`:  Individual macrofauna taxa and biomass
 - `biovolume_type`:  Macrofauna biovolume type
 - `ctd`: CTD downcast profiles
 - `env`: Seafloor environmental data
 - `tou`: Sediment total oxygen utilization data
 - `dou`: Sediment dissolved oxygen utilization data

Functions include:
 - `lwr()`: Estimate biovolume with Length-width Relationship
 - `cylinder()`: Estimate biovolume with cylinder equation
 - `cone()`: Estimate biovolume with cone equation
 - `ellipsoid()`: Estimate biovolume with ellipsoid equation
 - `add_coarse_taxa()`: Add coarse taxa for high resoluted taxon names
 - `assign_type()`: Assign volume estimation types to each individual
 - `calculate_biovolume()`: Calculate the biovolume of each individual with their respective body shape types
 - `cacluate_ophiuriod_size()`: Combine ophiuroids' arm and disc volumes

Use the following combination for calcualting the biovolume of each individuals with the data structure provided in the present package:
```
library(dplyr)

# define grouping variables for ophiuroid volume estimation
grouping_variables <-
  c("Cruise", "Habitat", "Station", "Deployment", "Tube", "Section")

# calculate the biovolume of each individual
data_biovolume_calculated <-
  data %>%
  # assign geometric shapes or LWR constant to each specimen
  assign_type() %>%
  # calculate biovolume to each specimen
  calculate_biovolume() %>%
  # sum up arms and discs of each ophiuroids
  calculate_ophiuriod_size(ophiuroid_method = "all_arms",
                           grouping_variables = grouping_variables)
```


Use the following code to download the package to your local R environment:

```
if (sum(as.data.frame(installed.packages())$Package %in% "devtools") < 1) {
  install.packages("devtools")
} else{
  devtools::install_github("chenyenting1998/GRSmacrofauna")
}
```

# Author
Yen-Ting Chen
