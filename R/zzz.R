etcd_GET <- function(url, args, ...) {
  res <- GET(url, query = args, ...)
  stop_for_status(res)
  content(res, "text")
}

etcd_PUT <- function(url, value, ttl=NULL, dir=FALSE, ...){
  if (missing(value)) {
    res <- PUT(url, query = list(dir = TRUE), ...)
  } else {
    res <- PUT(url, body = list(value = value), query = etc(list(ttl = ttl, dir = dir)), encode = "form", ...)
  }
  stop_for_status(res)
  content(res, "text")
}

etcd_POST <- function(url, value, ttl=NULL, ...) {
  res <- POST(url, body = list(value = value), query = etc(list(ttl = ttl)), encode = "form", ...)
  stop_for_status(res)
  content(res, "text")
}

etcd_DELETE <- function(url, args, ...){
  res <- DELETE(url, query = args, ...)
  if (res$status_code > 201) {
    warn_for_status(res)
    content(res)
  }
  content(res, "text")
}

etcd_parse <- function(x, simplify=FALSE){
  jsonlite::fromJSON(x, simplify)
}

etcdbase <- function() "http://127.0.0.1:4001/v2/"

etc <- function(l) Filter(Negate(is.null), l)
