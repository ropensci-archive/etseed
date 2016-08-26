#' etcd authentication - users
#'
#' @name users
#' @param user (character) User name to create/delete
#' @param password (character) Password to give the new user
#' @param roles (list/character vector) Roles to give the new user
#' @param auth_user,auth_pwd (character) Username and password for the authenticated user,
#' the root user
#' @param ... Further args passed on to \code{\link[httr]{GET}},
#' \code{\link[httr]{PUT}}, or \code{\link[httr]{DELETE}}
#' @examples \dontrun{
#' # make a client
#' cli <- etcd()
#'
#' # Add user
#' cli$user_add("jane", "janepwd", "root", "pickbetterpwd")
#'
#' # List users
#' cli$user_list()
#'
#' # Get a single user
#' cli$user_get("root")
#' cli$user_get("jane")
#'
#' # Delete user
#' cli$user_delete("jane", "root", "pickbetterpwd")
#' }
NULL
