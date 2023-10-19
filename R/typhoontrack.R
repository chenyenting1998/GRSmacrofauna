#' @title Typhoon Bailu track data
#'
#' @docType data
#' @author Yen-Ting Chen \email{r08241220@@ntu.edu.tw}
#' @details  The track data of the 2019 Typhoon Bailu.
#'            Data were downloaded from Jian et al. (2022).
#'   \itemize{
#'      \item{\code{Year}} The year of the typhoon.
#'      \item{\code{Name}} The name of the typhoon.
#'      \item{\code{Date}} Date in YYYY-MM-DD format.
#'      \item{\code{Time}} Time in HH-MM-SS format.
#'      \item{\code{Latitude}} Latitude in decimals..
#'      \item{\code{Longitude}} Longitude in decimals.
#'      \item{\code{Pressure}} The pressure at the center of the typhoon (hPa).
#'      \item{\code{Wind}} Average wind speed at the center of the typhoon (m/s).
#'      \item{\code{Gust}} Gust (maximum wind speed) at the center of the typhoon (m/s).
#'      \item{\code{7Dir}} The typhoon's force 7 wind radius (km).
#'      \item{\code{10Dir}} The typhoon's force 10 wind radius (km).
#'      \item{\code{Warn}} 0 represents no warning; 1 represents sea warning; 2 represents land warning; and 3 represents warning lifted.
#' }
#' @references
#'
#' @name typhoontrack
#' @keywords datasets
NULL

#' @rdname typhoontrack
"typhoontrack"
