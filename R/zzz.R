etcdbase <- function() "http://127.0.0.1:2379/v2/"
etcdhost <- function() "127.0.0.1"
etcdport <- function() "2379"

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

contutf8 <- function(x) {
  content(x, "text", encoding = "UTF-8")
}

etcd_parse <- function(x, simplify=FALSE){
  jsonlite::fromJSON(x, simplify)
}

make_auth <- function(user, pwd) {
  authenticate(user, pwd)
}

check_key <- function(x) {
  if (!grepl("^/", x)) {
    stop("The key must be prefixed by a '/'", call. = FALSE)
  }
  return(x)
}
