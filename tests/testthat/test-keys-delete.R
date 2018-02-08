context("etseed keys: delete")

client <- etcd()

test_that("keys - delete basic method works correctly", {
  skip_on_cran()
  skip_on_travis()

  # create randomly named key so it shouldn't exist already
  key <- paste0("/", paste0(sample(c(letters,' ','@'), 9), collapse = ""))
  invisible(client$create(key = key, value = "moon cow and saturn cheese"))

  aa <- client$delete(key = key)

  expect_is(client$delete, "function")
  expect_is(aa, "list")
  expect_named(aa, c('action', 'node', 'prevNode'))
  expect_is(aa$action, "character")
  expect_equal(aa$action, "delete")
  expect_is(aa$node, "list")
  expect_equal(aa$node$key, key)
  expect_null(aa$node$value)
  expect_is(aa$node$modifiedIndex, "integer")
  expect_is(aa$node$createdIndex, "integer")
  expect_is(aa$prevNode, "list")
  expect_equal(aa$prevNode$key, key)
  expect_is(aa$prevNode$modifiedIndex, "integer")
  expect_is(aa$prevNode$createdIndex, "integer")
})

test_that("keys - delete, dir param works correctly", {
  skip_on_cran()
  skip_on_travis()

  invisible(suppressWarnings(client$create(key = "/yodir", dir = TRUE)))

  # deleting a dir doesn't work unless `dir=TRUE`
  expect_warning(client$delete(key = "/yodir"), "Not a file")

  # works if `dir=TRUE`
  bb <- client$delete(key = "/yodir", dir = TRUE)
  expect_is(bb, "list")
  expect_equal(bb$action, "delete")
})
