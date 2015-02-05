#' List a key or all keys
#'
#' @import httr jsonlite
#' @name keys
#'
#' @param key (character) A key name. Optional.
#' @param value Any object to store. Required for \code{\link{create}}, \code{\link{update}},
#' and \code{\link{delete}} functions
#' @param ttl (integer) Seconds after which the key will be removed.
#' @param ... Further args passed on to \code{\link[httr]{GET}}
#'
#' @details \code{\link{create}} and \code{\link{update}} are essentially the same thing, but
#' get different names so as not to confuse people (eg. if create did create and update functions.)
#'
#' @examples \dontrun{
#' # Make a key
#' create(key="mykey", value="this is awesome")
#' create(key="things", value="and stuff!")
#' ## use ttl
#' create(key="stuff", value="tables", ttl=10)
#'
#' # Update a key
#' update(key="things", value="and stuff! and more things")
#'
#' # Create an in-order key
#' create_inorder("queue", "thing1")
#' create_inorder("queue", "thing2")
#' create_inorder("queue", "thing3")
#' key("queue", sorted = TRUE, recursive = TRUE)
#'
#' # List all keys
#' keys()
#' keys(sorted = TRUE)
#' keys(recursive = TRUE)
#' keys(sorted = TRUE, recursive = TRUE)
#'
#' # List a single key
#' key("mykey")
#' key("things")
#'
#' # Delete a key
#' create("hello", "world")
#' delete("hello")
#' ## Delete only if matches previous value, fails
#' delete("things", prevValue="two")
#' ## Delete only if matches previous index
#' ### Fails
#' delete("things", prevIndex=1)
#' ### Works
#' delete("things", prevIndex=13)
#'
#' # curl options
#' library("httr")
#' keys(config = verbose())
#' }

#' @export
#' @rdname keys
keys <- function(recursive = NULL, sorted = NULL, ...) {
  etcd_parse(etcd_GET(sprintf("%s%s/", etcdbase(), "keys"), list(recursive, sorted), ...))
}

#' @export
#' @rdname keys
key <- function(key, recursive = NULL, sorted = NULL, ...) {
  etcd_parse(etcd_GET(sprintf("%s%s/%s/", etcdbase(), "keys", key),
                      etc(list(recursive=recursive, sorted=sorted)), ...))
}

#' @export
#' @rdname keys
create <- function(key, value, ttl = NULL, ...) {
  etcd_parse(etcd_PUT(sprintf("%s%s/%s/", etcdbase(), "keys", key), value, ttl, ...))
}

#' @export
#' @rdname keys
update <- function(key, value, ttl = NULL, ...) {
  etcd_parse(etcd_PUT(sprintf("%s%s/%s/", etcdbase(), "keys", key), value, ttl, ...))
}

#' @export
#' @rdname keys
create_inorder <- function(key, value, ttl = NULL, ...) {
  etcd_parse(etcd_POST(sprintf("%s%s/%s/", etcdbase(), "keys", key), value, ttl, ...))
}

#' @export
#' @rdname keys
delete <- function(key, prevValue = NULL, prevIndex = NULL, ...) {
  etcd_parse(etcd_DELETE(sprintf("%s%s/%s/", etcdbase(), "keys", key),
                         etc(list(prevValue=prevValue, prevIndex=prevIndex)), ...))
}
