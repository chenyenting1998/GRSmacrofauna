#' @title Calculate the biovolume of each individual with their respective body shape types
#' @description Calculates biovolume of each individual with its assigned method.
#' @param data A long format data containing columns of Length (L), Width (W), and body shape type (Type).
#'
#' @return The same data frame with a new column called "Size" contains the volume data.
#' @export
#' @details Note that this function will first remove all the entries in the `Size` column.
#' @examples
#' a <- data.frame(
#'   L = c(10, 5, 6, 78, 1, 6),
#'   W = c(0.1, 3, 4, 1, 2, 3),
#'   Method = c("LWR", "LWR", "Cylinder", "Cylinder", "Cone", "Elliposid"),
#'   C = c(0.53, 0.45, NA, NA, NA, NA)
#' )
#' calculate_biovolume(a)
calculate_biovolume <- function(data) {

  # initial if_else control flow --------------------------------------------
  if (is.character(data)) {
    if (grepl(".xlsx", data)) { # data have ".xlsx"
      data <- read_xlsx(data) %>% data.frame()
    }
    if (grepl(".csv", data)) { # data have ".xlsx"
      data <- read.csv(data) %>% data.frame()
    }
  } else if (is.object(data)) { # data = object
    data <- data.frame(data)
  } else {
    message("data is not a .csv file, a .xlsx file, or an object")
    stop()
  }

  # Add a type column if such column does not exist
  if (!("Type" %in% colnames(data))) {
    message("data lacks a [Type] column")
    stop()
  }

  if (!"L" %in% colnames(data) | !"W" %in% colnames(data)) {
    message("Misses L and/or W for biovolume calculation")
    stop()
  }

  # calculate biovolume -----------------------------------------------------
  data_sizeNA <-
    data %>%
    mutate(Size = NA_real_) # add column and/or remove previous calculations

  # # LWR
  # data$Size <-
  #   if_else(data$Type == "LWR",
  #           lwr(data$L, data$W, data$C),
  #           data$Size)
  #
  # # cylinder
  # data$Size <-
  #   if_else(data$Type == "Cylinder",
  #           cylinder(data$L, data$W),
  #           data$Size)
  #
  # # cone
  # data$Size <-
  #   if_else(data$Type == "Cone",
  #           cone(data$L, data$W),
  #           data$Size)
  #
  # # ellipsoid
  # data$Size <-
  #   if_else(data$Type == "Ellipsoid",
  #           ellipsoid(data$L, data$W),
  #           data$Size)
  data_size_calculated <-
    data_sizeNA %>%
    mutate(
      Size = case_when(
        Type == "LWR" ~ lwr(Length = L, Width = W, Conversion_factor = C),
        Type == "Cylinder" ~ cylinder(Length = L, Width = W),
        Type == "Cone" ~ cone(Length = L, Width = W),
        Type == "Ellipsoid" ~ ellipsoid(Length = L, Width = W),
        TRUE ~ NA_real_
      )
    )

  # final check
  size_logic <- is.na(data_size_calculated$Size)
  # I did not block the output if there is no Size outputs.
  if(sum(size_logic) != length(size_logic)){
    # I add a comment on whether individuals have size calculated.
    cat("Caution: One or more individuals have no Size outputs.")
    print(data[is.na(data_size_calculated$Size),])
  }

  return(data_size_calculated)
}

