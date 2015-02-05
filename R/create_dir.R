#' Create a directory
#'
#' @param key (character) A key name. Optional.
#' @param ... Further args passed on to \code{\link[httr]{GET}}
#'
#' @examples \dontrun{
#' # Make a key
#' create_dir("newdir")
#' }

create_dir <- function(key, ...) {
  etcd_parse(etcd_PUT(sprintf("%s%s/%s/", etcdbase(), "keys", key), ...))
}
