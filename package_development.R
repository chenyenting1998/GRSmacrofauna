######################################
### GRSmacrofauna package development
######################################
# Author: Yen-Ting Chen
# Date of creation: 2023/06/27
# Last date of modification: 2023/06/27

##############
# Description
##############
# A list of packages and functions to rinse and repeat the
# package development process.

################
# Load packages
################
library(usethis)
library(devtools)
library(testthat)
library(knitr)
library(roxygen2)
load_all() # load GRSmacrofauna


############
# Functions
############
# to load the package in del.
load_all()
# to quickly examine all aspects of the package
check()
# write functions in NAMESPACE
document()
#
