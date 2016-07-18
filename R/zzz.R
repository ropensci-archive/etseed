etcd_GET <- function(url, args, ...) {
  if (length(args) == 0) args <- NULL
  res <- GET(url, query = args, ...)
  if (res$status_code > 201) {
    stop(content(res)$message, call. = FALSE)
  }
  content(res, "text")
}

etcd_PUT <- function(url, value, ttl=NULL, dir=FALSE, file=NULL, ...){
  if (missing(value) && is.null(file)) {
    res <- PUT(url, query = list(dir = TRUE), ...)
  } else {
    args <- etc(list(ttl = ttl, dir = dir))
    if (length(args) == 0) args <- NULL

    if (is.null(file)) {
      res <- PUT(url, body = list(value = value), query = args, encode = "form", ...)
    } else {
      stop("not working yet from files", call. = FALSE)
      # res <- PUT(url, body = list(value = upload_file(file)), query = args, encode = "form")
    }
  }
  stop_for_status(res)
  content(res, "text")
}

etcd_POST <- function(url, value, ttl=NULL, ...) {
  args <- etc(list(ttl = ttl))
  if (length(args) == 0) args <- NULL
  res <- POST(url, body = list(value = value), query = args, encode = "form", ...)
  stop_for_status(res)
  content(res, "text")
}

etcd_DELETE <- function(url, args, ...) {
  if (length(args) == 0) args <- NULL
  res <- DELETE(url, query = args, ...)
  if (res$status_code > 201) {
    warning(content(res)$message, call. = FALSE)
    content(res)
  }
  content(res, "text")
}

etcd_parse <- function(x, simplify=FALSE){
  jsonlite::fromJSON(x, simplify)
}

etcdbase <- function() "http://127.0.0.1:2379/v2/"

etc <- function(l) Filter(Negate(is.null), l)

asl <- function(z) {
  if (is.logical(z) || tolower(z) == "true" || tolower(z) == "false") {
    if (z) {
      return('true')
    } else {
      return('false')
    }
  } else {
    return(z)
  }
}
