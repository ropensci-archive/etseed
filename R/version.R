#' Get etcd version
#'
#' @export
#' @param ... Further args passed on to \code{\link[httr]{GET}}
#'
#' @examples \dontrun{
#' version()
#' }
version <- function(...) {
  etcd_parse(etcd_GET(sub("v2/", "version", etcdbase()), NULL, ...))
}
