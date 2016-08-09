#' A Function that Extracts all \code{.xls[x]} Files in a Folder
#'
#' Store all data in one list of lists (ie one list of workbooks, each
#' workbook is a list of sheets, each sheet is a dataframe (or an error message if applicable))
#'
#' @param folder Path to folder
#' @param general_case Args to be passed to \code{readxl::read_excel} for all sheets of all workbooks. Defaults to NULL.
#' @param weird_cases Args to be passed to \code{readxl::read_excel} for specific sheets. Overwrites general_case. Defaults to NULL. See \strong{Details}.
#'
#' @details \code{general_case} is one flat list of args (lines to skip and the like) to be passed to \code{readxl::read_excel} for all sheets.
#'     \code{weird_cases} is a nested list of such args for known specific cases.
#'     It is recommended you try to read the data without these argument at first, and then make adjustments according to outputs.
#'     The nested structure of \code{weird_cases} is \code{wb} (basename of Excel file) then \code{sheet} (name of a sheet) then args. See \code{Examples}.
#'     You may specify neither or one or both. If you specify both, \code{general_cases} is used and \code{weird_cases} overwrites it only where applicable.
#' @return A list of workbooks, each is a list of sheets as dataframes
#' @import magrittr
#' @importFrom stats setNames
#' @importFrom readxl excel_sheets read_excel
#' @export
#' @examples
#' \dontrun{
#' # Where your Excel files are located
#' folder <- "./excel data/"
#'
#' # First try without parameters
#' data_ <- extract_excel(folder)
#'
#' # View all data
#' view_excel(data_)
#'
#' # Second try with adjustments where things went wrong
#' weird_cases <- list(
#'   "first workbook.xls" = list(
#'     "sheet2" = list(skip = 3),
#'     "sheet3" = list(skip = 2)
#'   ),
#'   "wb2.xlsx" = list(
#'     "tab2" = list(skip = 3, col_names = FALSE)
#'   )
#' )
#' data_ <- extract_excel(folder, weird_cases)
#' }
extract_excel <- function(folder, general_case = NULL, weird_cases = NULL) {
  data_ <-
  # List all xls(x) files in folder (recursively)
  list.files(path = folder, pattern = "xlsx?$", full.names = TRUE,
             recursive = TRUE, ignore.case = TRUE) %>%
    setNames(nm = basename( . )) %>%
    # path is an xls(x) file name
    lapply(function(path) {
      # List all sheets in a file
      setNames(nm = excel_sheets(path)) %>%
        lapply(function(sheet) {
          read_excel_args <- general_case
          # Deal with specific cases
          if (!is.null(weird_cases[[path]][[sheet]])) {
            for (arg in names(weird_cases[[path]][[sheet]])) {
              read_excel_args[[arg]] <- weird_cases[[path]][[sheet]][[arg]]
            }
          }
          # Read data from Excel sheet
          tryCatch(
            do.call(read_excel, c(list(path = path, sheet = sheet), read_excel_args)) %>%
              # Remove empty rows
              subset(rowSums(is.na( . )) != ncol( . )) %>%
              # Remove empty columns
              Filter(f = function(col) any(!is.na(col))),
            # In case of error, store error message as character instead
            error = function(cond) as.character(cond)
          )
        })
    })
  # Show error messages
  for (wb in names(data_)) {
    for (sheet in names(data_[[wb]])) {
      if (!is.data.frame(data_[[wb]][[sheet]])) {
        cat("Info: Import of \"", wb, " -- ", sheet, "\" failed with error message:\n", sep = "")
        cat("    ", data_[[wb]][[sheet]], sep = "")
      }
    }
  }
  return(data_)
}
