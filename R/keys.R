#' List a key or all keys
#'
#' @import httr jsonlite
#' @name keys
#'
#' @param key (character) A key name. Optional.
#' @param ... Further args passed on to \code{\link[httr]{GET}}
#'
#' @examples \dontrun{
#' # List all keys
#' keys()
#'
#' # A single key
#' key("mykey")
#' }

#' @export
#' @rdname keys
keys <- function(...) {
  etcd_parse(etcd_GET(sprintf("%s%s/", etcdbase(), "keys"), ...))
}

#' @export
#' @rdname keys
key <- function(key, ...) {
  etcd_parse(etcd_GET(sprintf("%s%s/%s/", etcdbase(), "keys", key), ...))
}
