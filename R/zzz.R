etcd_GET <- function(url, ...){
  res <- GET(url, ...)
  stop_for_status(res)
  content(res, "text")
}

etcd_parse <- function(x, simplify=FALSE){
  jsonlite::fromJSON(x, simplify)
}

etcdbase <- function() "http://127.0.0.1:4001/v2/"
