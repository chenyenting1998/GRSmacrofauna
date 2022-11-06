#' @title  Assign volume estimation method in to each individuals
#'
#' @description This function adds the following two columns to your original data frame:
#'      \itemize{
#'      \item \code{Type} : This column stores the method for volume calculation.
#'      \item \code{C} : This column stores the conversion factors for individuals that uses
#'                       length-weight relationships for biomass calculation.
#'      }
#'
#' @param data The data that records observations of each individuals size measurements
#'             with at least the following column: "Taxon"
#' @param method_file The file that contains the pairwise biovolume estimation method.
#'                    Note that the method file has a specific format to follow. See
#'                    \code{biovolume method} for more information.
#'                    If NULL, the method file will use the default "biovolume_method"
#'                    data.
#' @return
#' @export
#'
#' @examples
#' # the default estimation method for each available taxon.
#' biovolume_method
#' a <- data.frame(Taxon = c("Polychaeta", "Oligochaeta", "Sipuncula", "Not in the column"))
#' assign_method(a)
assign_method <- function(data, method_file = NULL) {

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

  # assign method -----------------------------------------------------------
  if (is.null(method_file)) {
    method_file <- biovolume_method
  } else if (is.object(method_file)) {
    method_file <- method_file
  } else {
    stop("method file is neither NULL or an object")
  }

  # identify dup taxa
  dup_taxa <- unique(method_file$Taxon[duplicated(method_file$Taxon)])

  # separate method file into unique and duplicate cases
  dup_taxa_method <-
    method_file[method_file$Taxon %in% dup_taxa,] %>%
    select(Taxon, Note, Type, C)

  uni_taxa_method <-
    method_file[!method_file$Taxon %in% dup_taxa_method$Taxon,] %>%
    select(Taxon, Type, C)

  # left join
  result_unique <-
    data %>%
    # use !duplicate to keep the unassigned individuals
    filter(!Taxon %in% dup_taxa_method$Taxon) %>%
    left_join(uni_taxa_method, by = "Taxon")

  result_duplicate <-
    data %>%
    filter(Taxon %in% dup_taxa_method$Taxon) %>%
    left_join(dup_taxa_method, by = c("Taxon", "Note"))

  # assign conversion factors for organisms that uses LWR
  output <- full_join(result_unique, result_duplicate)

  if (any(is.na(output$Type))) {
    cat("The following observations do not have methods", "\n")
    print(output[is.na(output$Type),])
  }
    output
}


