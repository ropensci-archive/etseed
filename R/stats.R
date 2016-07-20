#' Get etcd statistics
#'
#' @name stats
#' @param which (character) one of leader (default), self, or store
#' @param pretty (logical) parse text to an R list, or not. Default: \code{TRUE}
#' @param ... Further args passed on to \code{\link[httr]{GET}}
#' @return Prints a human readable text representation to console.
#' @examples \dontrun{
#' # make a client
#' cli <- etcd()
#'
#' # leader stats
#' cli$stats()
#'
#' # self stats
#' cli$stats("self")
#'
#' # store stats
#' cli$stats("store")
#'
#' # Prety or not
#' cli$stats(pretty = TRUE)
#' cli$stats(pretty = FALSE)
#' }
NULL
