context("version")

test_that("etcd version method works", {
  aa <- etcd()

  res <- aa$version()

  expect_is(res, "list")
  expect_named(res, c('etcdserver', 'etcdcluster'))
  expect_identical(res, aa$ping())
})
