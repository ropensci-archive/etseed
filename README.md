etseed
========



[![Build Status](https://api.travis-ci.org/ropensci/etseed.png)](https://travis-ci.org/ropensci/etseed)
[![Build status](https://ci.appveyor.com/api/projects/status/80oy29dhgw3tvy4k?svg=true)](https://ci.appveyor.com/project/sckott/etseed-04dte)


__etcd R client__

`etcd` is a key-value DB written in `Go`. It has an HTTP API, which this R package wraps. 

[etcd API docs](https://github.com/coreos/etcd/blob/master/Documentation/api.md)

_note: for some reason, I'm getting failures connecting with the HTTP API once in a while, haven't tracked down the problem yet...sorry_ 

## Installation

Install `etseed`


```r
install.packages("devtools")
devtools::install_github("ropensci/etseed")
```


```r
library("etseed")
```

## Start etcd

at the command line on OSX

```sh
brew install etcd
etcd
```

done.

## Get version


```r
version()
#> [1] "etcd 0.4.6"
```

## Create a directory




```r
create("/neighbor", dir = TRUE)
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
create(key = "/mykey", value = "this is awesome")
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
create(key = "/stuff", value = "tables", ttl = 5)
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
#> [1] "2015-04-24T07:23:38.377140689-07:00"
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
key("/stuff")
#> Error in etcd_GET(sprintf("%s%s/%s/", etcdbase(), "keys", key), ...) : 
#>   client error: (404) Not Found 
```

## Update a key



Create a key


```r
create(key = "/foo", value = "bar")
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
update(key = "/foo", value = "bar stool")
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
create_inorder("/queue", "thing1")
#> $action
#> [1] "create"
#> 
#> $node
#> $node$key
#> [1] "/queue/197"
#> 
#> $node$value
#> [1] "thing1"
#> 
#> $node$modifiedIndex
#> [1] 197
#> 
#> $node$createdIndex
#> [1] 197
```


```r
create_inorder("/queue", "thing2")
#> $action
#> [1] "create"
#> 
#> $node
#> $node$key
#> [1] "/queue/198"
#> 
#> $node$value
#> [1] "thing2"
#> 
#> $node$modifiedIndex
#> [1] 198
#> 
#> $node$createdIndex
#> [1] 198
```


```r
create_inorder("/queue", "thing3")
#> $action
#> [1] "create"
#> 
#> $node
#> $node$key
#> [1] "/queue/199"
#> 
#> $node$value
#> [1] "thing3"
#> 
#> $node$modifiedIndex
#> [1] 199
#> 
#> $node$createdIndex
#> [1] 199
```

## List keys


```r
keys()
#> $action
#> [1] "get"
#> 
#> $node
#> $node$key
#> [1] "/"
#> 
#> $node$dir
#> [1] TRUE
#> 
...
```

## List a key


```r
key("/mykey")
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

## Meta

* Please [report any issues or bugs](https://github.com/ropensci/etseed/issues).
* License: MIT
* Citation: execute `citation(package = 'etseed')`

[![ropensci_footer](http://ropensci.org/public_images/github_footer.png)](http://ropensci.org)
