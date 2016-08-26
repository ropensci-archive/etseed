context("etseed client")

test_that("etcd static variables set correctly", {
  aa <- etcd()

  expect_is(aa, "EtcdClient")
  expect_is(aa, "R6")
  expect_is(aa$allow_redirect, "logical")
  expect_true(aa$allow_redirect)
  expect_is(aa$api_version, "character")
  expect_equal(aa$api_version, "v2")
  expect_is(aa$host, "character")
  expect_equal(aa$host, "127.0.0.1")
  expect_is(aa$port, "numeric")
  expect_equal(aa$port, 2379)
  expect_is(aa$scheme, "character")
  expect_equal(aa$scheme, "http")
})
