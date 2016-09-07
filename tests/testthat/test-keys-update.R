context("etseed keys: update")

client <- etcd()

test_that("keys - update basic method works correctly", {
  skip_on_cran()
  skip_on_travis()

  # create randomly named key so it shouldn't exist already
  key <- paste0("/", paste0(sample(letters, 9), collapse = ""))
  invisible(client$create(key = key, value = "moon cow and saturn cheese"))

  aa <- client$update(key = key, value = "saturn cow and moon cheese")

  expect_is(client$update, "function")
  expect_is(aa, "list")
  expect_named(aa, c('action', 'node', 'prevNode'))
  expect_is(aa$action, "character")
  expect_equal(aa$action, "set")
  expect_is(aa$node, "list")
  expect_equal(aa$node$key, key)
  expect_equal(aa$node$value, "saturn cow and moon cheese")
  expect_is(aa$node$modifiedIndex, "integer")
  expect_is(aa$node$createdIndex, "integer")
  expect_is(aa$prevNode, "list")
  expect_equal(aa$prevNode$key, key)
  expect_equal(aa$prevNode$value, "moon cow and saturn cheese")
  expect_is(aa$prevNode$modifiedIndex, "integer")
  expect_is(aa$prevNode$createdIndex, "integer")
})

test_that("keys - update, ttl param works correctly", {
  skip_on_cran()
  skip_on_travis()

  key <- paste0("/", paste0(sample(letters, 9), collapse = ""))

  invisible(suppressWarnings(client$create(key = key, value = "aaa")))

  aa <- client$update(key = key, value = "bbb", ttl = 2)

  # key should exist immediately after
  expect_is(client$key(key = key), "list")
  # after sleeping 2 sec, it's gone
  Sys.sleep(3)
  expect_error(client$key(key = key), "Key not found")
})
