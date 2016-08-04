#' Summarize Output of extract_excel
#'
#' @param data_ A list of list of dataframes, as returned by \code{\link{extract_excel}}
#'
#' @return A dataframe that summarizes extracted Excel data
#' @export
#'
summary_excel <- function(data_) {
  # Summarize imported data in a dataframe with nrow and ncol of each dataset
  summary_ <-
    lapply(names(data_), function(workbook) {
      lapply(names(data_[[workbook]]), function(sheet) {
        data.frame(
          "workbook" = workbook,
          "sheet" = sheet,
          "nrow" = if (!is.null(nrow(data_[[workbook]][[sheet]]))) nrow(data_[[workbook]][[sheet]]) else NA_integer_,
          "ncol" = if (!is.null(ncol(data_[[workbook]][[sheet]]))) ncol(data_[[workbook]][[sheet]]) else NA_integer_
        )
      }) %>% do.call(what = "rbind")
    }) %>% do.call(what = "rbind")
}
