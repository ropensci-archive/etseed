#' List a key or all keys
#'
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
#' @details \code{\link{create}} and \code{\link{update}} are essentially the same
#' thing, but get different names so as not to confuse people (eg. if create did
#' create and update functions.)
#'
#' @section Headers:
#' You can get header info on requests via curl options like
#' \code{key("/mykey", config = verbose())}, but make sure to load \code{httr} first.
#' Headers include in particular three useful ones that provide global information about
#' the etcd cluster that serviced a request:
#' \itemize{
#'  \item X-Etcd-Index: the current etcd index as explained above. When request is a watch
#'  on key space, X-Etcd-Index is the current etcd index when the watch starts, which means
#'  that the watched event may happen after X-Etcd-Index.
#'  \item X-Raft-Index: similar to the etcd index but is for the underlying raft protocol
#'  \item X-Raft-Term is an integer that will increase whenever an etcd master election
#'  happens in the cluster. If this number is increasing rapidly, you may need to tune
#'  the election timeout. See the tuning
#'  (\url{https://github.com/coreos/etcd/blob/master/Documentation/tuning.md}) section
#'  for details.
#' }
#'
#' @examples \dontrun{
#' # Make a key
#' create(key="/mykey", value="this is awesome")
#' create(key="/things", value="and stuff!")
#' ## use ttl (expires after ttl seconds)
#' create(key="/stuff", value="tables", ttl=10)
#'
#' # Make a directory
#' create(key="/mydir", dir = TRUE)
#' # List a directory
#' key("/mydir")
#' # Make a key inside a directory
#' create("/mydir/key1", value = "foo")
#' create("/mydir/key2", value = "bar")
#' # List again, now with two keys
#' key("/mydir")
#' # Delete a directory
#' delete(key="/mydir", dir = TRUE)
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
#' # key("/anewkey", wait = TRUE, wait_index = 7)
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
#'
#' # Hidden keys
#' ## Create a hidden key using "_" at beginning
#' create("/_message", "my hidden key")
#' ## A key that's not hidden
#' create("/message", "my un-hidden key")
#' ## Call to root directory doesn't show the hidden key
#' keys()
#'
#' # Set a key from a file
#' cat("hello\nworld", file = "myfile.txt")
#' create("/myfile", file = file)
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
create <- function(key, value = NULL, file = NULL, ttl = NULL, dir = FALSE, ...) {
  etcd_parse(etcd_PUT(sprintf("%s%s%s", etcdbase(), "keys", check_key(key)), value, ttl, dir, file, ...))
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
                         etc(list(prevValue = prevValue, prevIndex = prevIndex, dir = dir,
                                  recursive = recursive)), ...))
}

check_key <- function(x) {
  if (!grepl("^/", x)) {
    stop("The key must be prefixed by a '/'",
         call. = FALSE)
  }
  return(x)
}
