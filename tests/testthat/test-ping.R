context("ping")

test_that("etcd ping method works", {
	skip_on_cran()
  skip_on_travis()

  aa <- etcd()

  res <- aa$ping()

  expect_is(res, "list")
  expect_named(res, c('etcdserver', 'etcdcluster'))
})
