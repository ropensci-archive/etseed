#' etcd authentication - users
#'
#' @name users
#' @aliases user_list user_add user_get user_delete
#'
#' @param user (character) User name to create/delete
#' @param password (character) Password to give the new user
#' @param roles (list/character vector) Roles to give the new user
#' @param auth_user,auth_pwd (character) Username and password for the authenticated user,
#' the root user
#' @param ... Further args passed on to \code{\link[httr]{GET}},
#' \code{\link[httr]{PUT}}, or \code{\link[httr]{DELETE}}
#'
#' @return see return for each method
#'
#' @section Methods:
#' \itemize{
#'  \item user_list: list users, a list of users
#'  \item user_add: add a user, a list with slots \code{user} and \code{roles}
#'  \item user_get: get a user by name, a list with slots \code{user}
#'  and \code{roles} (if any exist)
#'  \item user_delete: delete a user by name, returns nothing on success
#' }
#'
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
