###################################
### Typhoon track data cleaning ###
###################################
# Author: Yen-Ting Chen
# Date of creation: 2023/10/17
# Last date of modification: 2023/10/20

library(usethis)
# set path
path <- unz("data-raw/2019.TrackData.zip", "2019_TrackData/2019.BAILU.TrackBEST.txt")
# read data
data <- read.table(path, skip = 1)
# add column name
colnames(data) <- c("Year", "Name", "Date", "Time",
                    "Latitude", "Longitude", "Press", "Wind",
                    "Gust", "7Dir", "10Dir", "Warn")

# format time
data$Date <- as.POSIXlt(data$Date)
data$Time <- as.POSIXlt(data$Time)
class(data$Date)
class(data$Time)
# rename data
typhoontrack<- data

##########
# output #
##########
use_data(typhoontrack, overwrite = T)

