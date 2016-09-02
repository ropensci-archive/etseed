#' Get etcd metrics
#'
#' @name metrics
#' @param pretty (logical) Print easier to read with newlines, or as a single string.
#' Default: \code{TRUE}
#' @param ... Further args passed on to \code{\link[httr]{GET}}
#' @return Prints a human readable text representation to console
#' of the metrics of your etcd cluster
#'
#' @examples \dontrun{
#' # make a client
#' cli <- etcd()
#'
#' cli$metrics()
#' cli$metrics(pretty = FALSE)
#' }
NULL
