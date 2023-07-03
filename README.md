# GRSmacrofauna

# Description
This is a data package containing biological data, environmental data, and self-defined R functions.

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
 -  `cacluate_ophiuriod_size()`: Combine of ophiuroids' arm and disc volume

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
