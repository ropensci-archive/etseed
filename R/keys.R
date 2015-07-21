#' List a key or all keys
#'
#' @import httr jsonlite
#' @name keys
#'
#' @param key (character) A key name. Optional.
#' @param value Any object to store. Required for \code{\link{create}}, \code{\link{update}},
#' and \code{\link{delete}} functions
#' @param recursive Whether to do recursive something???
#' @param sorted Whether to return sorted or not.
#' @param prevValue (character) Previous value to match against.
#' @param prevIndex (integer) Previous index to match against.
#' @param ttl (integer) Seconds after which the key will be removed.
#' @param dir (logical) Whether to crate or delete a directory or not
#' @param wait (logical) Whether to wait or not for a key change. Deafult: \code{FALSE}
#' @param wait_index (integer) Index to wait until
#' @param ... Further args passed on to \code{\link[httr]{GET}}
#'
#' @details \code{\link{create}} and \code{\link{update}} are essentially the same thing, but
#' get different names so as not to confuse people (eg. if create did create and update functions.)
#'
#' @examples \dontrun{
#' # Make a key
#' create(key="/mykey", value="this is awesome")
#' create(key="/things", value="and stuff!")
#' ## use ttl
#' create(key="/stuff", value="tables", ttl=10)
#'
#' # Update a key
#' update(key="/things", value="and stuff! and more things")
#'
#' # Create an in-order key
#' create_inorder("/queue", "thing1")
#' create_inorder("/queue", "thing2")
#' create_inorder("/queue", "thing3")
#' key("/queue", sorted = TRUE, recursive = TRUE)
#'
#' # List all keys
#' keys()
#' keys(sorted = TRUE)
#' keys(recursive = TRUE)
#' keys(sorted = TRUE, recursive = TRUE)
#'
#' # List a single key
#' key("/mykey")
#' key("/things")
#'
#' # Waiting
#' ## Wait for a change via long-polling
#' ## in another R session, load etseed, then run the 2nd line of code
#' # key("/anewkey", wait = TRUE)
#' # create("/anewkey", "hey from another R session")
#' ## Wait for change from cleared event index
#' key("/anewkey", wait = TRUE, wait_index = 7)
#'
#' # Delete a key
#' create("/hello", "world")
#' delete("/hello")
#' ## Delete only if matches previous value, fails
#' delete("/things", prevValue="two")
#' ## Delete only if matches previous index
#' ### Fails
#' delete("/things", prevIndex=1)
#' ### Works
#' delete("/things", prevIndex=13)
#'
#' # curl options
#' library("httr")
#' keys(config = verbose())
#' }

#' @export
#' @rdname keys
keys <- function(recursive = NULL, sorted = NULL, ...) {
  etcd_parse(etcd_GET(sprintf("%s%s/", etcdbase(), "keys"),
                       etc(list(recursive = recursive, sorted = sorted)), ...))
}

#' @export
#' @rdname keys
key <- function(key, recursive = NULL, sorted = NULL, wait = FALSE, wait_index = NULL, ...) {
  etcd_parse(etcd_GET(sprintf("%s%s%s", etcdbase(), "keys", check_key(key)),
                      etc(list(recursive = recursive, sorted = sorted,
                               wait = asl(wait), waitIndex = wait_index)), ...))
}

#' @export
#' @rdname keys
create <- function(key, value = NULL, ttl = NULL, dir = FALSE, ...) {
  etcd_parse(etcd_PUT(sprintf("%s%s%s", etcdbase(), "keys", check_key(key)), value, ttl, dir, ...))
}

#' @export
#' @rdname keys
update <- function(key, value, ttl = NULL, ...) {
  etcd_parse(etcd_PUT(sprintf("%s%s%s", etcdbase(), "keys", check_key(key)), value, ttl, ...))
}

#' @export
#' @rdname keys
create_inorder <- function(key, value, ttl = NULL, ...) {
  etcd_parse(etcd_POST(sprintf("%s%s%s", etcdbase(), "keys", check_key(key)), value, ttl, ...))
}

#' @export
#' @rdname keys
delete <- function(key, prevValue = NULL, prevIndex = NULL, dir = FALSE, recursive = NULL, ...) {
  etcd_parse(etcd_DELETE(sprintf("%s%s%s", etcdbase(), "keys", check_key(key)),
                         etc(list(prevValue=prevValue, prevIndex=prevIndex, dir=dir, recursive = recursive)), ...))
}

check_key <- function(x) {
  stopifnot(grepl("^/", x))
  x
}
