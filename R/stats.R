#' Get etcd statistics
#'
#' @export
#' @param which (character) one of leader (default), self, or store
#' @param pretty (logical) parse text to an R list, or not. Default: \code{TRUE}
#' @param ... Further args passed on to \code{\link[httr]{GET}}
#' @return Prints a human readable text representation to console.
#' @examples \dontrun{
#' # leader stats
#' stats()
#'
#' # self stats
#' stats("self")
#'
#' # store stats
#' stats("store")
#'
#' # Prety or not
#' stats(pretty = TRUE)
#' stats(pretty = FALSE)
#' }
stats <- function(which = "leader", pretty = TRUE, ...) {
  res <- etcd_GET(paste0(etcdbase(), "stats/", which), NULL, ...)
  if (pretty) {
    jsonlite::fromJSON(res)
  } else {
    res
  }
}
