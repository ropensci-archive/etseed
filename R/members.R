#' Manage etcd members
#'
#' @name members
#' @aliases member_list member_add member_change member_delete
#'
#' @param id (character) A member id
#' @param newid (logical) new member id
#' @param ... Further args passed on to \code{\link[httr]{GET}}
#'
#' @return Logical or a list, see Methods for what each returns
#'
#' @details Be careful with these commands
#'
#' @section Methods:
#' \itemize{
#'  \item member_list: list all members, a list of members
#'  \item member_add: add a member, a list of info just added
#'  \item member_change: change a member, may not be working quite yet
#'  \item member_delete: delete a member, returns nothing on success
#' }
#'
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
#' # cli$member_add("http://10.0.0.10:2380")
#'
#' # change a member - not sure this is working...
#' ## mms <- cli$member_list()
#' ## cli$member_change(mms$members[[1]]$id, "http://10.0.0.10:8380", config=verbose())
#'
#' # delete a member
#' # mms <- cli$member_list()
#' # cli$member_delete(mms$members[[1]]$id)
#' }
NULL
