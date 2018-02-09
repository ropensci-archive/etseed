context("etseed keys: keys")

client <- etcd()

test_that("keys - keys basic method works correctly", {
  skip_on_cran()
  skip_on_travis()

  # create some key/value pairs
  keys <- replicate(10, paste0("/", paste0(sample(c(letters,' ','@'), 9), collapse = "")))
  values <- replicate(10, paste0(sample(words, 10), collapse = " "))
  invisible(
    Map(function(x, y) {
      client$create(key = x, value = y)
    }, keys, values)
  )

  aa <- client$keys()

  expect_is(client$keys, "function")
  expect_is(aa, "list")
  expect_named(aa, c('action', 'node'))
  expect_is(aa$action, "character")
  expect_equal(aa$action, "get")
  expect_is(aa$node, "list")
  expect_true(aa$node$dir)
  expect_is(aa$node$nodes, "list")
  expect_is(aa$node$nodes[[1]], "list")
  expect_is(aa$node$nodes[[1]]$key, "character")
  cat(aa$node$nodes[[1]]$value)
  expect_is(aa$node$nodes[[1]]$modifiedIndex, "integer")
  expect_is(aa$node$nodes[[1]]$createdIndex, "integer")
})

test_that("keys - recursive param works correctly", {
  skip_on_cran()
  skip_on_travis()

  invisible(delete_all_keys(client))

  key <- make_key()
  dir <- client$create(key = key, dir = TRUE)
  client$create(key = paste0(key, make_key()), value = "stuff and things")
  client$create(key = paste0(key, make_key()), value = "apples and pears")

  aa <- client$keys(recursive = TRUE)
  bb <- client$keys(recursive = FALSE)

  # all keys gotten
  expect_is(aa, "list")
  expect_equal(aa$action, "get")
  expect_true(aa$node$dir)
  expect_gt(length(aa$node$nodes[[1]]), 1)

  # only the dir
  expect_is(bb, "list")
  expect_equal(bb$action, "get")
  expect_true(bb$node$dir)
  expect_equal(length(bb$node$nodes[1]), 1)
})

test_that("keys - sorted param works correctly", {
  skip_on_cran()
  skip_on_travis()

  invisible(delete_all_keys(client))

  key <- make_key()
  dir <- client$create(key = key, dir = TRUE)
  client$create(key = paste0(key, make_key()), value = "stuff and things")
  client$create(key = paste0(key, make_key()), value = "apples and pears")
  client$create(key = paste0(key, make_key()), value = "farts")
  client$create(key = paste0(key, make_key()), value = "cheese")

  aa <- client$keys(sorted = TRUE, recursive = TRUE)
  bb <- client$keys(sorted = FALSE, recursive = TRUE)

  # sorted
  xx <- vapply(aa$node$nodes[[1]]$nodes, function(x) strsplit(x[['key']], "/")[[1]][[3]], "")
  expect_equal(xx, sort(xx))

  # not sorted
  zz <- vapply(bb$node$nodes[[1]]$nodes, function(x) strsplit(x[['key']], "/")[[1]][[3]], "")
  expect_false(identical(zz, sort(zz)))
})
