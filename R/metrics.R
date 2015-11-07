#' Get etcd metrics
#'
#' @export
#' @param pretty (logical) Print easier to read with newlines, or as a single string.
#' Default: \code{TRUE}
#' @param ... Further args passed on to \code{\link[httr]{GET}}
#' @return Prints a human readable text representation to console.
#' @examples \dontrun{
#' metrics()
#' metrics(FALSE)
#' }

metrics <- function(pretty = TRUE, ...) {
  res <- etcd_GET(sub("v2/", "metrics", etcdbase()), NULL, ...)
  if (pretty) {
    cat(res)
  } else {
    res
  }
}
