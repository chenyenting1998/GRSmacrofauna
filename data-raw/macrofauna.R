################################
### macrofauna data cleaning ###
################################

# Description
# Cleaning macrofauna data by merging data from Yen-Ting and Yen-Li

library(readxl)
library(dplyr)
library(usethis)
library(data.table)
library(devtools)
library(testthat)
library(knitr)
library(roxygen2)
load_all()

# read OR1_1219 data --------
or1_1219_macro_raw =
  read_xlsx("data-raw/OR1_1219_macro_size_final.xlsx",
            col_types = c(rep("guess", 7), rep("text", 2), rep("guess", 8))) %>%
  setDT()

# remove S7-2-3
or1_1219_macro_raw <- or1_1219_macro_raw[!(or1_1219_macro_raw$Station == "S7" & or1_1219_macro_raw$Tube == 3)]

# add the revised S7-2-3
S7_2_3 <-
  read_xlsx("data-raw/OR1-1219_S7-2-3.xlsx",
            col_types = c(rep("guess", 7), rep("text", 2), rep("guess", 8))) %>%
  setDT()

# merge data
or1_1219_macro_raw = merge(or1_1219_macro_raw, S7_2_3, all = TRUE)

# add section
or1_1219_macro_raw$Section <- "0-10"

# read 0r1_1219_poly ----
or1_1219_poly =
  read_xlsx("data-raw/OR1_1219_polychaeta_size.xlsx",
            col_types = c(rep("guess", 7), rep("text", 2), rep("guess", 8))) %>%
  setDT()

# reset column order
setcolorder(or1_1219_poly, colnames(or1_1219_macro_raw))

# data cleaning
or1_1219_poly$Deployment = as.numeric( gsub(".*-", "",or1_1219_poly$Station))
or1_1219_poly$Station = gsub("-.*", "",or1_1219_poly$Station)
or1_1219_poly$Section = as.character(or1_1219_poly$Section)
or1_1219_poly$Section = "0-10"

# merge data
OR1_1219_macro_mea = merge(as.data.frame(or1_1219_macro_raw), or1_1219_poly, all = TRUE)

# read OR1_1242 data ----
or1_1242_macro_raw =
  read_xlsx("data-raw/OR1_1242_macro_size_final.xlsx",
            col_types = c(rep("guess", 7), rep("text", 2), rep("guess", 8))) %>%
  setDT()

setcolorder(or1_1242_macro_raw, colnames(or1_1219_macro_raw))

# read and process or1_1242 poly ----
or1_1242_poly =
  read_xlsx("data-raw/OR1_1242_polychaeta_size.xlsx",
            col_types = c(rep("guess", 7), rep("text", 2), rep("guess", 7))) %>%
  setDT()
or1_1242_poly$Note <- NA

# set column order
setcolorder(or1_1242_poly, colnames(or1_1219_macro_raw))

# data cleaning
or1_1242_poly$Section = as.character(or1_1242_poly$Section)
or1_1242_poly$Section = "0-10"

# merge data
OR1_1242_macro_mea = merge(or1_1242_macro_raw[Taxon != "Polychaeta",], or1_1242_poly, all = TRUE)

# remove redundant data ------------
rfgab <- function(data){
  data$Family <- NULL
  data$Genus <- NULL
  data$a <- NULL
  data$b <- NULL
  data
}

OR1_1219_macro_mea <- rfgab(OR1_1219_macro_mea)
OR1_1242_macro_mea <- rfgab(OR1_1242_macro_mea)

# add habitat -----
add_habitat <- function(data, criteria, output){
  if_else(data$Station %in% criteria,
          output,
          data$Habitat)
}

# 1219
OR1_1219_macro_mea$Habitat <- add_habitat(OR1_1219_macro_mea, "GS1", "Slope")
OR1_1219_macro_mea$Habitat <- add_habitat(OR1_1219_macro_mea, "GC1", "Canyon")
OR1_1219_macro_mea$Habitat <- add_habitat(OR1_1219_macro_mea, paste0(rep("S", 7), 1:7), "Shelf")

# 1242
OR1_1242_macro_mea$Habitat <- add_habitat(OR1_1242_macro_mea, "GS1", "Slope")
OR1_1242_macro_mea$Habitat <- add_habitat(OR1_1242_macro_mea, "GC1", "Canyon")
OR1_1242_macro_mea$Habitat <- add_habitat(OR1_1242_macro_mea, paste0(rep("S", 7), 1:7), "Shelf")

# Cruise _ to - ====
OR1_1219_macro_mea$Cruise <- gsub("_", "-", OR1_1219_macro_mea$Cruise)
OR1_1242_macro_mea$Cruise <- gsub("_", "-", OR1_1242_macro_mea$Cruise)

# remove data containing GC1 and GS1 ====
OR1_1219_macro_mea <- OR1_1219_macro_mea[!OR1_1219_macro_mea$Station %in% c("GS1", "GC1"),]
OR1_1242_macro_mea <- OR1_1242_macro_mea[!OR1_1242_macro_mea$Station %in% c("GS1", "GC1"),]

# output
use_data(OR1_1219_macro_mea, internal = TRUE, overwrite = TRUE)
use_data(OR1_1242_macro_mea, internal = TRUE, overwrite = TRUE)
