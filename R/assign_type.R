#' @title  Assign volume estimation types to each individual
#'
#' @description This function adds the following two columns to your original data frame:
#'      \itemize{
#'      \item \code{Type} : This column stores the type for volume calculation.
#'      \item \code{C} : This column stores the conversion factors for individuals that uses
#'                       length-weight relationships for biomass calculation.
#'      }
#'
#' @param data The data that records observations of each individuals size measurements
#'             with at least the following column: "Taxon"
#' @param type_file The file that contains the pairwise biovolume estimation type.
#'                    Note that the type file has a specific format to follow. See
#'                    \code{biovolume type} for more information.
#'                    If NULL, the type file will use the default "biovolume_type"
#'                    data.
#' @return
#' @export
#' @details The original `Type` column will be overwritten with the `Type` provided in `type_file`.
#' @examples
#' # the default estimation type for each available taxon.
#' biovolume_type
#' a <- data.frame(Taxon = c("Polychaeta", "Oligochaeta", "Sipuncula", "Not in the column"))
#' assign_type(a)
assign_type <- function(data, type_file = NULL) {

  # initial if_else control flow --------------------------------------------
  if (is.character(data)) {
    if (grepl(".xlsx", data)) { # measurement_file have ".xlsx"
      data <- read_xlsx(data) %>% data.frame()
    }
    if (grepl(".csv", data)) { # measurement_file have ".xlsx"
      data <- read.csv(data) %>% data.frame()
    }
  } else if (is.object(data)) { # measurement_file = object
    data <- data.frame(data)
  } else {
    stop("Neither measurement_file nor object")
  }

  # assign type -----------------------------------------------------------
  if (is.null(type_file)) {
    type_file <- biovolume_type
  } else if (is.object(type_file)) {
    type_file <- type_file
  } else {
    stop("type file is neither NULL or an object")
  }

  # identify duplicated taxa
  dup_taxa <- unique(type_file$Taxon[duplicated(type_file$Taxon)])

  # separate type file into unique and duplicated cases
  # duplicated
  dup_taxa_type <-
    type_file[type_file$Taxon %in% dup_taxa,] %>%
    select(Taxon, Note, Type, C)

  # unique
  uni_taxa_type <-
    type_file[!type_file$Taxon %in% dup_taxa_type$Taxon,] %>%
    select(Taxon, Type, C)

  # combining columns
  result_unique <-
    data %>%
    # use !duplicate to keep the unassigned individuals
    filter(!Taxon %in% dup_taxa_type$Taxon) %>%
    select(-Type) %>%
    left_join(uni_taxa_type, by = "Taxon")

  result_duplicate <-
    data %>%
    filter(Taxon %in% dup_taxa_type$Taxon) %>%
    select(-Type) %>%
    left_join(dup_taxa_type, by = c("Taxon", "Note"))

  # assign conversion factors for organisms that uses LWR
  output <- full_join(result_unique, result_duplicate)

  if (any(is.na(output$Type))) {
    cat("The following observations do not have types", "\n")
    print(output[is.na(output$Type),])
  }
    return(output)
}


