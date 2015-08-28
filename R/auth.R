#' etcd authentication - auth control
#'
#' @name auth
#' @export
#' @param auth_user,auth_pwd (character) Username and password for the authenticated user,
#' the root user
#' @param ... Further args passed on to \code{\link[httr]{GET}},
#' \code{\link[httr]{PUT}}, or \code{\link[httr]{DELETE}}
#' @examples \dontrun{
#' # check authentication status
#' auth_status()
#'
#' # enable authentication
#' auth_enable()
#'
#' # woops, if you got error about root user, craeate one first
#' add_user(user = "root", password = "pickbetterpwd")
#'
#' # disable authentication
#' auth_disable("root", "pickbetterpwd")
#'
#' # check again, now disabled
#' auth_status()
#'
#' # Users
#' # Add user
#' user_add("jane", "janepwd", "root", "pickbetterpwd")
#' # List users
#' user_list()
#' # Get a single user
#' user_get("root")
#' user_get("jane")
#' # Delete user
#' user_delete("jane", "root", "pickbetterpwd")
#' }

#' @export
#' @rdname auth
auth_status <- function(...) {
  res <- etcd_GET(paste0(etcdbase(), "auth/enable"), NULL, ...)
  jsonlite::fromJSON(res)
}

#' @export
#' @rdname auth
auth_enable <- function(...) {
  auth_PUT(paste0(etcdbase(), "auth/enable"), ...)
}

#' @export
#' @rdname auth
auth_disable <- function(auth_user, auth_pwd, ...) {
  res <- etcd_DELETE(paste0(etcdbase(), "auth/enable"), NULL,
                     make_auth(auth_user, auth_pwd), ...)
  jsonlite::fromJSON(res)
}

auth_PUT <- function(url, ...) {
  tt <- PUT(url, ..., encode = "json")
  if (tt$status_code > 201) {
    stop(content(tt)$message, call. = FALSE)
  }
  res <- content(tt, "text")
  jsonlite::fromJSON(res)
}

auth_DELETE <- function(url, args, ...) {
  if (length(args) == 0) args <- NULL
  res <- DELETE(url, query = args, ...)
  if (res$status_code > 201) {
    stop(content(res)$message, call. = FALSE)
  }
  content(res, "text")
}

make_auth <- function(user, pwd) {
  authenticate(user, pwd)
}
