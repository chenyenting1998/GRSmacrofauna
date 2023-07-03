#' @title Estimate biovolume with cylinder equation
#' @description Estimate the biovolume of individuals with cylinder equation.
#'
#' @param Length Length of an organism
#' @param Width Width of an organism
#'
#' @return The volume
#' @export
#'
#' @examples
#' cylinder(15, 0.75)
cylinder <- function(Length, Width) {
  x <- Length * (Width / 2) * (Width / 2) * pi
  return(x)
}
