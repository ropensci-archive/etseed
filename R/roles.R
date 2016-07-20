#' etcd authentication - roles
#'
#' @name roles
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
#'
#' @examples \dontrun{
#' # make a client
#' cli <- etcd()
#'
#' # Add role
#' perms <- list(fun = list(kv = list(read = "/message/*")))
#' cli$role_add("fun", perms, auth_user="root", auth_pwd="pickbetterpwd")
#'
#' # List roles
#' cli$role_list()
#'
#' # Get a single role
#' cli$role_get("root")
#' cli$role_get("fun")
#'
#' # Delete role
#' cli$role_delete("fun", "root", "pickbetterpwd")
#'
#' # Update a role
#' ### FIXME - still working on this
#' ## First, create
#' # cli$role_add("stuff", perm_read = "/message/*", perm_write = "/message/*",
#' #    auth_user = "root", auth_pwd = "pickbetterpwd")
#' ## udpate
#' # "xxx"
#' ## get
#' # cli$role_get("stuff")
#' }
NULL
