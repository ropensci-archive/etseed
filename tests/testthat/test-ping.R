context("ping")

test_that("etcd ping method works", {
  aa <- etcd()

  res <- aa$ping()

  expect_is(res, "list")
  expect_named(res, c('etcdserver', 'etcdcluster'))
})
