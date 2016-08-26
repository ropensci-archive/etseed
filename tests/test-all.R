library("testthat")

# make a client
cli <- etseed::etcd()

# get all keys
kys <- cli$keys()

# delete all keys
invisible(
  lapply(kys$node$nodes, function(z) {
    if ('dir' %in% names(z)) {
      cli$delete(key = z$key, dir = TRUE, recursive = TRUE)
    } else {
      cli$delete(z$key)
    }
  })
)

# tests
test_check("etseed")
