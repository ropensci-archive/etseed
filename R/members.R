#' Manage etcd members
#'
#' @name members
#' @param id (character) A member id
#' @param newid (logical) new member id
#' @param ... Further args passed on to \code{\link[httr]{GET}}
#' @return Logical or R list
#' @examples \dontrun{
#' Sys.setenv(ETSEED_USER = "root")
#' Sys.setenv(ETSEED_PWD = "pickbetterpwd")
#'
#' # make a client
#' cli <- etcd()
#'
#' # list members
#' cli$member_list()
#'
#' # add a member
#' cli$member_add("http://10.0.0.10:2380")
#'
#' # change a member
#' mms <- cli$member_list()
#' cli$member_change(mms$members[[1]]$id, "http://10.0.0.10:8380", config=verbose())
#'
#' # delete a member
#' mms <- cli$member_list()
#' cli$member_delete(mms$members[[1]]$id)
#' }
NULL
