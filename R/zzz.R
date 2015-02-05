etseed_GET <- function(url, ...){
  res <- GET(url, ...)
  stop_for_status(res)
  tt <- content(res, "text")
  jsonlite::fromJSON(tt, FALSE)
}

etcdbase <- function() "http://127.0.0.1:4001/v2/"
