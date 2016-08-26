<!--
%\VignetteEngine{knitr::knitr}
%\VignetteIndexEntry{Introduction to etseed}
%\VignetteEncoding{UTF-8}
-->



`etcd` is a key-value DB written in `Go`. It has an HTTP API, which this R package wraps.

[etcd API docs](https://github.com/coreos/etcd/blob/master/Documentation/v2/api.md)

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
#> [1] "3.0.4"
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
#> [1] 190
#> 
#> $node$createdIndex
#> [1] 190
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
#> [1] 192
#> 
#> $node$createdIndex
#> [1] 192
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
#> [1] "2016-08-26T00:24:40.87244088Z"
#> 
#> $node$ttl
#> [1] 5
#> 
#> $node$modifiedIndex
#> [1] 193
#> 
#> $node$createdIndex
#> [1] 193
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
#> [1] 195
#> 
#> $node$createdIndex
#> [1] 195
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
#> Error in etcd_POST(sprintf("%s%s%s", private$make_url(), "keys", check_key(key)), : Not Found (HTTP 404).
```


```r
client$create_inorder("/queue", "thing2")
#> Error in etcd_POST(sprintf("%s%s%s", private$make_url(), "keys", check_key(key)), : Not Found (HTTP 404).
```


```r
client$create_inorder("/queue", "thing3")
#> Error in etcd_POST(sprintf("%s%s%s", private$make_url(), "keys", check_key(key)), : Not Found (HTTP 404).
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
#> [1] 192
#> 
#> $node$createdIndex
#> [1] 192
```
