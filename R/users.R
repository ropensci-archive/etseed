#' etcd authentication - users
#'
#' @name users
#' @export
#' @param user (character) User name to create/delete
#' @param password (character) Password to give the new user
#' @param roles (list/character vector) Roles to give the new user
#' @param auth_user,auth_pwd (character) Username and password for the authenticated user,
#' the root user
#' @param ... Further args passed on to \code{\link[httr]{GET}},
#' \code{\link[httr]{PUT}}, or \code{\link[httr]{DELETE}}
#' @examples \dontrun{
#' # Add user
#' user_add("jane", "janepwd", "root", "pickbetterpwd")
#'
#' # List users
#' user_list()
#'
#' # Get a single user
#' user_get("root")
#' user_get("jane")
#'
#' # Delete user
#' user_delete("jane", "root", "pickbetterpwd")
#' }

#' @export
#' @rdname users
user_add <- function(user, password, auth_user, auth_pwd, roles = NULL, ...) {
  args <- etc(list(user = user, password = password, roles = roles))
  auth_PUT(paste0(etcdbase(), paste0("auth/users/", user)),
           body = args, make_auth(auth_user, auth_pwd), ...)
}

#' @export
#' @rdname users
user_list <- function(...) {
  res <- etcd_GET(paste0(etcdbase(), "auth/users/"), NULL, ...)
  jsonlite::fromJSON(res)
}

#' @export
#' @rdname users
user_get <- function(user, ...) {
  res <- etcd_GET(paste0(etcdbase(), paste0("auth/users/", user)), NULL, ...)
  jsonlite::fromJSON(res)
}

#' @export
#' @rdname users
user_delete <- function(user, auth_user, auth_pwd, ...) {
  invisible(etcd_DELETE(paste0(etcdbase(), paste0("auth/users/", user)),
                        NULL, make_auth(auth_user, auth_pwd), ...))
}
