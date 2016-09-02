#' List a key or all keys
#'
#' @name keys
#' @aliases key create create_in_order delete update
#'
#' @param key (character) A key name. Optional.
#' @param value Any object to store. Required for \code{create}, \code{update},
#' and \code{delete} functions
#' @param recursive Whether to do recursive something???
#' @param sorted Whether to return sorted or not.
#' @param prevValue (character) Previous value to match against.
#' @param prevIndex (integer) Previous index to match against.
#' @param ttl (integer) Seconds after which the key will be removed.
#' @param dir (logical) Whether to crate or delete a directory or not
#' @param wait (logical) Whether to wait or not for a key change.
#' Deafult: \code{FALSE}
#' @param wait_index (integer) Index to wait until
#' @param ... Further args passed on to \code{\link[httr]{GET}}
#'
#' @return All return a list, with named slots 'action' and 'node'. If
#' the key previously existed, or is deleted, or updated,
#' you get an addition slot 'prevNode'. The action slot tells you
#' what action you took. the 'node' slot gives the key name, its
#' value, a 'modifiedIndex' and a 'createdIndex'
#'
#' @section Methods:
#' \itemize{
#'  \item key: get a single key
#'  \item keys: get all keys
#'  \item create: create a key
#'  \item create_in_order: create a key in order
#'  \item update: update a key
#'  \item delete: delete a key
#' }
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
#' @section Setting a key from file:
#' Note that setting a key from a file is not working yet.
#'
#' @examples \dontrun{
#' # make a client
#' cli <- etcd()
#'
#' # Make a key
#' cli$create(key="/mykey", value="this is awesome")
#' cli$create(key="/things", value="and stuff!")
#' ## use ttl (expires after ttl seconds)
#' cli$create(key="/stuff", value="tables", ttl=10)
#'
#' # Make a directory
#' cli$create(key="/mydir", dir = TRUE)
#' # List a directory
#' cli$key("/mydir")
#' # Make a key inside a directory
#' cli$create("/mydir/key1", value = "foo")
#' cli$create("/mydir/key2", value = "bar")
#' # List again, now with two keys
#' cli$key("/mydir")
#' # Delete a directory
#' cli$delete(key="/mydir", dir = TRUE)
#'
#' # Update a key
#' cli$update(key="/things", value="and stuff! and more things")
#'
#' # Create an in-order key
#' cli$create_inorder("/queue", "thing1")
#' cli$create_inorder("/queue", "thing2")
#' cli$create_inorder("/queue", "thing3")
#' cli$key("/queue", sorted = TRUE, recursive = TRUE)
#'
#' # List all keys
#' cli$keys()
#' cli$keys(sorted = TRUE)
#' cli$keys(recursive = TRUE)
#' cli$keys(sorted = TRUE, recursive = TRUE)
#'
#' # List a single key
#' cli$key("/mykey")
#' cli$key("/things")
#'
#' # Waiting
#' ## Wait for a change via long-polling
#' ## in another R session, load etseed, then run the 2nd line of code
#' # cli$key("/anewkey", wait = TRUE)
#' # cli$create("/anewkey", "hey from another R session")
#' ## Wait for change from cleared event index
#' # cli$key("/anewkey", wait = TRUE, wait_index = 7)
#'
#' # Delete a key
#' cli$create("/hello", "world")
#' cli$delete("/hello")
#' ## Delete only if matches previous value, fails
#' cli$delete("/things", prevValue="two")
#' ## Delete only if matches previous index
#' ### Fails
#' cli$delete("/things", prevIndex=1)
#' ### Works
#' cli$delete("/things", prevIndex=13)
#'
#' # curl options
#' library("httr")
#' cli$keys(config = verbose())
#'
#' # Hidden keys
#' ## Create a hidden key using "_" at beginning
#' cli$create("/_message", "my hidden key")
#' ## A key that's not hidden
#' cli$create("/message", "my un-hidden key")
#' ## Call to root directory doesn't show the hidden key
#' cli$keys()
#'
#' # Set a key from a file
#' # cat("hello\nworld", file = "myfile.txt")
#' # cli$create("/myfile", file = file)
#' }
NULL
