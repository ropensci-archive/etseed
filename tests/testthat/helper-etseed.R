make_key <- function() {
  paste0("/", paste0(sample(letters, 9), collapse = ""))
}

delete_all_keys <- function(x) {
  kys <- x$keys()
  lapply(kys$node$nodes, function(z) {
    if ('dir' %in% names(z)) {
      x$delete(key = z$key, dir = TRUE, recursive = TRUE)
    } else {
      x$delete(z$key)
    }
  })
}

load("words.rda")
