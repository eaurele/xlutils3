#' View the Output of extract_excel
#'
#' @description A wrapper for `View`
#'
#' @param data_ A list of list of dataframes, as returned by \code{\link{extract_excel}}
#'
#' @return Returns \code{NULL} invisibly.
#' @details \code{View} all dataframes stored in the output of \code{\link{extract_excel}} at once.
#' @importFrom utils View
#' @export
#'
view_excel <- function(data_) {
  # View all imported data
  lapply(names(data_), function(workbook) {
    lapply(names(data_[[workbook]]), function(sheet) {
      View(data_[[workbook]][[sheet]], title = paste(workbook, sheet, sep = " -- ")) })
  }) %>% invisible
  invisible(NULL)
}
