#' etcd authentication - roles
#'
#' @name roles
#' @export
#' @param role (character) Role to act upon
#' @param perm_read Read permission to set
#' @param perm_write Write permission to set
#' @param grant_read Grant read permission to set
#' @param grant_write Grant write permission to set
#' @param revoke_read Revoke read permission to set
#' @param revoke_write Revoke write permission to set
#' @param auth_user,auth_pwd (character) Username and password for the authenticated user,
#' the root user
#' @param ... Further args passed on to \code{\link[httr]{GET}},
#' \code{\link[httr]{PUT}}, or \code{\link[httr]{DELETE}}
#' @examples \dontrun{
#' # Add role
#' perms <- list(fun = list(kv = list(read = "/message/*")))
#' role_add("fun", perms, "root", "pickbetterpwd")
#'
#' # List roles
#' role_list()
#'
#' # Get a single role
#' role_get("root")
#' role_get("fun")
#'
#' # Delete role
#' role_delete("fun", "root", "pickbetterpwd")
#'
#' # Update a role
#' ### FIXME - still working on this
#' ## First, create
#' role_add("stuff", perm_read = "/message/*", perm_write = "/message/*",
#'    auth_user = "root", auth_pwd = "pickbetterpwd")
#' ## udpate
#' "xxx"
#' ## get
#' role_get("stuff")
#' }

#' @export
#' @rdname roles
role_add <- function(role, perm_read = NULL, perm_write = NULL,
                     grant_read = NULL, grant_write = NULL,
                     revoke_read = NULL, revoke_write = NULL,
                     auth_user, auth_pwd, ...) {

  args <- etc(list(role = role,
    permissions = list(kv = list(read = perm_read, write = perm_write)),
    grant = list(kv = list(read = grant_read, write = grant_write)),
    revoke = list(kv = list(read = revoke_read, write = revoke_write))
  ))
  auth_PUT(paste0(etcdbase(), paste0("auth/roles/", role)),
           body = args, make_auth(auth_user, auth_pwd), ...)
}

#' @export
#' @rdname roles
role_list <- function(...) {
  res <- etcd_GET(paste0(etcdbase(), "auth/roles/"), NULL, ...)
  jsonlite::fromJSON(res)
}

#' @export
#' @rdname roles
role_get <- function(role, ...) {
  res <- etcd_GET(paste0(etcdbase(), paste0("auth/roles/", role)), NULL, ...)
  jsonlite::fromJSON(res)
}

#' @export
#' @rdname roles
role_delete <- function(role, auth_role, auth_pwd, ...) {
  invisible(auth_DELETE(paste0(etcdbase(), paste0("auth/roles/", role)),
                        NULL, make_auth(auth_role, auth_pwd), ...))
}
