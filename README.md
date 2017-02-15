etseed
========



[![Build Status](https://travis-ci.org/ropensci/etseed.svg?branch=master)](https://travis-ci.org/ropensci/etseed)
[![rstudio mirror downloads](http://cranlogs.r-pkg.org/badges/etseed)](https://github.com/metacran/cranlogs.app)
[![cran version](http://www.r-pkg.org/badges/version/etseed)](https://cran.r-project.org/package=etseed)
[![codecov.io](https://codecov.io/github/ropensci/etseed/coverage.svg?branch=master)](https://codecov.io/github/ropensci/etseed?branch=master)

__etcd R client__

`etcd` is a key-value DB written in `Go`. It has an HTTP API, which this R package wraps.

[etcd API docs](https://github.com/coreos/etcd/blob/master/Documentation/v2/api.md)

Development follows closely the newest version of `etcd` released by the Coreos folks. As of
2016-09-07 that's `etcd v3.0.7`

## Installing etcd

See the [etcd Github repo](https://github.com/coreos/etcd#etcd) for help on installing `etcd`.

There are various ways to install it, and they depend on your operating sytsem.

You can install via `homebrew`, install from source, and via Docker.

## Start etcd

at the command line

```sh
etcd
```

> how to start etcd may differ depending on your setup

## Installing etseed

Install `etseed`


```r
install.packages("etseed")
```

Development version


```r
install.packages("devtools")
devtools::install_github("ropensci/etseed")
```


```r
library("etseed")
```

## Make a client

First task when using this package is to initialize a client
with the `etcd()` function. it's a wrapper around an R6 class.


```r
(client <- etcd())
#> <etcd client>
#>   host: 127.0.0.1
#>   port: 2379
#>   api_version: v2
#>   scheme: http
#>   allow redirect: TRUE
```

Default settings in `etcd()` connect you to `localhost`, and port `2379`,
using etcd API version 2, with an `http` scheme.

## Get version


```r
client$version()
#> $etcdserver
#> [1] "3.0.7"
#>
#> $etcdcluster
#> [1] "3.0.0"
```

## Create a directory




```r
client$create("/neighbor", dir = TRUE)
#> $action
#> [1] "set"
#>
#> $node
#> $node$key
#> [1] "/neighbor"
#>
#> $node$dir
#> [1] TRUE
#>
#> $node$modifiedIndex
#> [1] 156
#>
#> $node$createdIndex
#> [1] 156
```

## Create a key




```r
client$create(key = "/mykey", value = "this is awesome")
#> $action
#> [1] "set"
#>
#> $node
#> $node$key
#> [1] "/mykey"
#>
#> $node$value
#> [1] "this is awesome"
#>
#> $node$modifiedIndex
#> [1] 158
#>
#> $node$createdIndex
#> [1] 158
```



Use `ttl` parameter to make it dissappear after `x` seconds


```r
client$create(key = "/stuff", value = "tables", ttl = 5)
#> $action
#> [1] "set"
#>
#> $node
#> $node$key
#> [1] "/stuff"
#>
#> $node$value
#> [1] "tables"
#>
#> $node$expiration
#> [1] "2016-09-07T17:21:08.993528228Z"
#>
#> $node$ttl
#> [1] 5
#>
#> $node$modifiedIndex
#> [1] 159
#>
#> $node$createdIndex
#> [1] 159
```

And the key will be gone after 5 seconds, see:


```r
client$key("/stuff")
#> Error in etcd_GET(sprintf("%s%s/%s/", etcdbase(), "keys", key), ...) :
#>   client error: (404) Not Found
```

## Update a key



Create a key


```r
client$create(key = "/foo", value = "bar")
#> $action
#> [1] "set"
#>
#> $node
#> $node$key
#> [1] "/foo"
#>
#> $node$value
#> [1] "bar"
#>
#> $node$modifiedIndex
#> [1] 161
#>
#> $node$createdIndex
#> [1] 161
```

Then update the key


```r
client$update(key = "/foo", value = "bar stool")
#> $action
#> [1] "set"
#>
#> $node
#> $node$key
#> [1] "/foo"
#>
#> $node$value
#> [1] "bar stool"
#>
...
```

## Create in-order keys


```r
client$create_inorder("/queue", "thing1")
#> $action
#> [1] "create"
#>
#> $node
#> $node$key
#> [1] "/queue/00000000000000000163"
#>
#> $node$value
#> [1] "thing1"
#>
#> $node$modifiedIndex
#> [1] 163
#>
#> $node$createdIndex
#> [1] 163
```


```r
client$create_inorder("/queue", "thing2")
#> $action
#> [1] "create"
#>
#> $node
#> $node$key
#> [1] "/queue/00000000000000000164"
#>
#> $node$value
#> [1] "thing2"
#>
#> $node$modifiedIndex
#> [1] 164
#>
#> $node$createdIndex
#> [1] 164
```


```r
client$create_inorder("/queue", "thing3")
#> $action
#> [1] "create"
#>
#> $node
#> $node$key
#> [1] "/queue/00000000000000000165"
#>
#> $node$value
#> [1] "thing3"
#>
#> $node$modifiedIndex
#> [1] 165
#>
#> $node$createdIndex
#> [1] 165
```

## List keys


```r
client$keys()
#> $action
#> [1] "get"
#>
#> $node
#> $node$dir
#> [1] TRUE
#>
#> $node$nodes
#> $node$nodes[[1]]
#> $node$nodes[[1]]$key
...
```

## List a key


```r
client$key("/mykey")
#> $action
#> [1] "get"
#>
#> $node
#> $node$key
#> [1] "/mykey"
#>
#> $node$value
#> [1] "this is awesome"
#>
#> $node$modifiedIndex
#> [1] 158
#>
#> $node$createdIndex
#> [1] 158
```

## Meta

* Please [report any issues or bugs](https://github.com/ropensci/etseed/issues).
* License: MIT
* Citation: execute `citation(package = 'etseed')`
* Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.

[![ropensci_footer](http://ropensci.org/public_images/github_footer.png)](http://ropensci.org)
