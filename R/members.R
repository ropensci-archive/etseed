#' Manage etcd members
#'
#' @export
#' @name members
#' @param id (character) A member id
#' @param newid (logical) new member id
#' @param ... Further args passed on to \code{\link[httr]{GET}}
#' @return Logical or R list
#' @examples \dontrun{
#' Sys.setenv(ETSEED_USER = "root")
#' Sys.setenv(ETSEED_PWD = "pickbetterpwd")
#'
#' # list members
#' member_list()
#'
#' # add a member
#' member_add("http://10.0.0.10:2380")
#'
#' # change a member
#' mms <- member_list()
#' member_change(mms$members[[1]]$id, "http://10.0.0.10:8380", config=verbose())
#'
#' # delete a member
#' mms <- member_list()
#' member_delete(mms$members[[1]]$id)
#' }
member_list <- function(...) {
  res <- etcd_GET(paste0(etcdbase(), "members"), NULL, ...)
  jsonlite::fromJSON(res, FALSE)
}

#' @export
#' @rdname members
member_add <- function(id, ...) {
  res <- member_POST(paste0(etcdbase(), "members"),
                     body = list(peerURLs = list(id)),
                     make_auth(Sys.getenv("ETSEED_USER"), Sys.getenv("ETSEED_PWD")), ...)
  jsonlite::fromJSON(res, FALSE)
}

#' @export
#' @rdname members
member_change <- function(id, newid, ...) {
  res <- member_PUT(paste0(etcdbase(), "members/", id),
                    body = list(peerURLs = list(newid)),
                    make_auth(Sys.getenv("ETSEED_USER"), Sys.getenv("ETSEED_PWD")), ...)
  jsonlite::fromJSON(res, FALSE)
}

#' @export
#' @rdname members
member_delete <- function(id, ...) {
  res <- member_DELETE(paste0(etcdbase(), "members/", id),
                       make_auth(Sys.getenv("ETSEED_USER"), Sys.getenv("ETSEED_PWD")), ...)
  identical(res, "")
}

member_POST <- function(url, ...) {
  res <- POST(url, encode = "json", ...)
  stop_for_status(res)
  content(res, "text")
}

member_PUT <- function(url, ...) {
  res <- PUT(url, encode = "json", ...)
  stop_for_status(res)
  content(res, "text")
}

member_DELETE <- function(url, ...) {
  res <- DELETE(url, encode = "json", ...)
  stop_for_status(res)
  content(res, "text")
}

