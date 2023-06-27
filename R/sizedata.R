#' @title Individual size data of all cruises
#'
#' @docType data
#' @author Yen-Ting Chen \email{r08241220@@ntu.edu.tw}
#' @details  The condition and unit of each column were listed below.
#'   \itemize{
#'      \item{\code{Cruise}} The cruise during sampling.
#'      \item{\code{Habitat}} Habitat type (shelf, slope, canyon)
#'      \item{\code{Station}} Sampling station.
#'      \item{\code{Deployment}} Number of deployment.
#'      \item{\code{Tube}} Order of tubes.
#'      \item{\code{Section}} sampled section in cm
#'      \item{\code{Taxon}} Recorded grouping taxa of the specimen
#'      \item{\code{Family}} Recorded family of the specimen
#'      \item{\code{Genus}} Recorded genus of the specimen
#'      \item{\code{Condition}} The condition of the specimen
#'      \item{\code{Type}} The respective geometric shapes for biovolume estimation
#'      \item{\code{L}} maximum body length in mm
#'      \item{\code{W}} maximum body length in mm
#'      \item{\code{C}} The conversion factors for biovolume estimation
#'      \item{\code{Size}} The volume of the specimen in mm^3
#'      \item{\code{WM}} Wet mass in mg; calculated from `Size` with the assumption
#'                       of 1.13 specific gravity (Gerlach et al., 1985)
#'      \item{\code{Note}} Comments and further information for the specimen
#' }
#' @references
#'
#' @name sizedata
#' @keywords datasets
NULL

#' @rdname sizedata
"macrofauna_measurements"
#' @rdname sizedata
"macrofauna_biomass"
