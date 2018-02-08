url_encode2 <- function(x) {
  if (length(x) == 0) {
    NULL
  } else if (is.list(x)) {
    setNames(lapply(x,url_encode2),names(x))
  } else if (is.character(x)) {
    setNames(url_encode(x),names(x))
  } else {
    x
  }
}

etcd_GET <- function(url, args, ...) {
  url <- url_encode2(url)
  args <- url_encode2(args)
  res <- GET(url, query = args, ...)
  if (res$status_code > 201) {
    stop(content(res)$message, call. = FALSE)
  }
  contutf8(res)
}

etcd_PUT <- function(url, value, ttl=NULL, dir=FALSE, file=NULL, ...){
  url <- url_encode2(url)
  if (missing(value) && is.null(file)) {
    res <- PUT(url, query = list(dir = TRUE), ...)
  } else {
    args <- etc(list(ttl = ttl, dir = dir))
    if (length(args) == 0) args <- NULL

    if (is.null(file)) {
      res <- PUT(url, body = list(value = value), query = args, encode = "form", ...)
    } else {
      stop("not working yet from files", call. = FALSE)
      # res <- PUT(url, body = list(value = upload_file(file)), query = args, encode = "form", ...)
    }
  }
  stop_for_status(res)
  contutf8(res)
}

etcd_POST <- function(url, value, ttl=NULL, ...) {
  url <- url_encode2(url)
  args <- etc(list(ttl = ttl))
  if (length(args) == 0) args <- NULL
  res <- POST(url, body = list(value = value), query = args, encode = "form", ...)
  stop_for_status(res)
  contutf8(res)
}

etcd_DELETE <- function(url, args, ...) {
  url <- url_encode2(url)
  args <- url_encode2(args)
  res <- DELETE(url, query = args, ...)
  if (res$status_code > 201) {
    warning(content(res)$message, call. = FALSE)
    content(res)
  }
  contutf8(res)
}

auth_PUT <- function(url, ...) {
  url <- url_encode2(url)
  tt <- PUT(url, ..., encode = "json")
  if (tt$status_code > 201) {
    stop(content(tt)$message, call. = FALSE)
  }
  contutf8(tt)
}

auth_PUT2 <- function(url, ...) {
  url <- url_encode2(url)
  tt <- PUT(url, ..., encode = "form")
  if (tt$status_code > 201) {
    stop(content(tt)$message, call. = FALSE)
  }
  contutf8(tt)
}

auth_DELETE <- function(url, args, ...) {
  url <- url_encode2(url)
  args <- url_encode2(args)
  res <- DELETE(url, query = args, ...)
  if (res$status_code > 201) {
    stop(content(res)$message, call. = FALSE)
  }
  contutf8(res)
}

member_POST <- function(url, ...) {
  url <- url_encode2(url)
  res <- POST(url, encode = "json", ...)
  stop_for_status(res)
  contutf8(res)
}

member_PUT <- function(url, ...) {
  url <- url_encode2(url)
  res <- PUT(url, encode = "json", ...)
  stop_for_status(res)
  contutf8(res)
}

member_DELETE <- function(url, ...) {
  url <- url_encode2(url)
  res <- DELETE(url, encode = "json", ...)
  stop_for_status(res)
  contutf8(res)
}

user_PUT <- function(url, ...) {
  url <- url_encode2(url)
  tt <- PUT(url, ..., encode = "json")
  if (tt$status_code > 201) {
    stop(content(tt)$message, call. = FALSE)
  }
  res <- contutf8(tt)
  jsonlite::fromJSON(res)
}
