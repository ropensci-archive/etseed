etseed
========



[![Build Status](https://api.travis-ci.org/ropensci/etseed.png)](https://travis-ci.org/ropensci/etseed)

__etcd R client__

`etcd` is a key-value DB written in `Go`. It has an HTTP API, which this R package wraps. 

[etcd API docs](https://github.com/coreos/etcd/blob/master/Documentation/api.md)

_note: for some reason, I'm getting failures connecting with the HTTP API once in a while, haven't tracked down the problem yet...sorry_ 

## Installation

Install `etseed`


```r
install.packages("devtools")
devtools::install_github("sckott/etseed")
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
create("neighbor", dir=TRUE)
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
#> [1] 70
#> 
#> $node$createdIndex
#> [1] 70
```

## Create a key




```r
create(key="mykey", value="this is awesome")
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
#> [1] 72
#> 
#> $node$createdIndex
#> [1] 72
```



Use `ttl` parameter to make it dissappear after `x` seconds


```r
create(key="stuff", value="tables", ttl=5)
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
#> [1] "2015-02-16T09:27:44.473632895-08:00"
#> 
#> $node$ttl
#> [1] 5
#> 
#> $node$modifiedIndex
#> [1] 73
#> 
#> $node$createdIndex
#> [1] 73
```

And the key will be gone after 5 seconds, see:


```r
key("stuff")
#> Error in etcd_GET(sprintf("%s%s/%s/", etcdbase(), "keys", key), ...) : 
#>   client error: (404) Not Found 
```

## Update a key



Create a key


```r
create(key="foo", value="bar")
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
#> [1] 75
#> 
#> $node$createdIndex
#> [1] 75
```

Then update the key


```r
update(key="foo", value="bar stool")
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
#> $node$modifiedIndex
#> [1] 76
#> 
#> $node$createdIndex
#> [1] 76
#> 
#> 
#> $prevNode
#> $prevNode$key
#> [1] "/foo/"
#> 
#> $prevNode$value
#> [1] "bar"
#> 
#> $prevNode$modifiedIndex
#> [1] 75
#> 
#> $prevNode$createdIndex
#> [1] 75
```

## Create in-order keys


```r
create_inorder("queue", "thing1")
#> $action
#> [1] "create"
#> 
#> $node
#> $node$key
#> [1] "/queue/77"
#> 
#> $node$value
#> [1] "thing1"
#> 
#> $node$modifiedIndex
#> [1] 77
#> 
#> $node$createdIndex
#> [1] 77
```


```r
create_inorder("queue", "thing2")
#> $action
#> [1] "create"
#> 
#> $node
#> $node$key
#> [1] "/queue/78"
#> 
#> $node$value
#> [1] "thing2"
#> 
#> $node$modifiedIndex
#> [1] 78
#> 
#> $node$createdIndex
#> [1] 78
```


```r
create_inorder("queue", "thing3")
#> $action
#> [1] "create"
#> 
#> $node
#> $node$key
#> [1] "/queue/79"
#> 
#> $node$value
#> [1] "thing3"
#> 
#> $node$modifiedIndex
#> [1] 79
#> 
#> $node$createdIndex
#> [1] 79
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
#> $node$nodes
#> $node$nodes[[1]]
#> $node$nodes[[1]]$key
#> [1] "/foo"
#> 
#> $node$nodes[[1]]$value
#> [1] "bar stool"
#> 
#> $node$nodes[[1]]$modifiedIndex
#> [1] 76
#> 
#> $node$nodes[[1]]$createdIndex
#> [1] 76
#> 
#> 
#> $node$nodes[[2]]
#> $node$nodes[[2]]$key
#> [1] "/mykey"
#> 
#> $node$nodes[[2]]$value
#> [1] "this is awesome"
#> 
#> $node$nodes[[2]]$modifiedIndex
#> [1] 72
#> 
#> $node$nodes[[2]]$createdIndex
#> [1] 72
#> 
#> 
#> $node$nodes[[3]]
#> $node$nodes[[3]]$key
#> [1] "/neighbor"
#> 
#> $node$nodes[[3]]$dir
#> [1] TRUE
#> 
#> $node$nodes[[3]]$modifiedIndex
#> [1] 70
#> 
#> $node$nodes[[3]]$createdIndex
#> [1] 70
#> 
#> 
#> $node$nodes[[4]]
#> $node$nodes[[4]]$key
#> [1] "/stuff"
#> 
#> $node$nodes[[4]]$value
#> [1] "tables"
#> 
#> $node$nodes[[4]]$expiration
#> [1] "2015-02-16T09:27:44.473632895-08:00"
#> 
#> $node$nodes[[4]]$ttl
#> [1] 5
#> 
#> $node$nodes[[4]]$modifiedIndex
#> [1] 73
#> 
#> $node$nodes[[4]]$createdIndex
#> [1] 73
#> 
#> 
#> $node$nodes[[5]]
#> $node$nodes[[5]]$key
#> [1] "/hello"
#> 
#> $node$nodes[[5]]$value
#> [1] ""
#> 
#> $node$nodes[[5]]$modifiedIndex
#> [1] 32
#> 
#> $node$nodes[[5]]$createdIndex
#> [1] 32
#> 
#> 
#> $node$nodes[[6]]
#> $node$nodes[[6]]$key
#> [1] "/howdy"
#> 
#> $node$nodes[[6]]$dir
#> [1] TRUE
#> 
#> $node$nodes[[6]]$modifiedIndex
#> [1] 35
#> 
#> $node$nodes[[6]]$createdIndex
#> [1] 35
#> 
#> 
#> $node$nodes[[7]]
#> $node$nodes[[7]]$key
#> [1] "/newdir"
#> 
#> $node$nodes[[7]]$dir
#> [1] TRUE
#> 
#> $node$nodes[[7]]$modifiedIndex
#> [1] 34
#> 
#> $node$nodes[[7]]$createdIndex
#> [1] 34
#> 
#> 
#> $node$nodes[[8]]
#> $node$nodes[[8]]$key
#> [1] "/queue"
#> 
#> $node$nodes[[8]]$dir
#> [1] TRUE
#> 
#> $node$nodes[[8]]$modifiedIndex
#> [1] 21
#> 
#> $node$nodes[[8]]$createdIndex
#> [1] 21
```

## List a key


```r
key("mykey")
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
#> [1] 72
#> 
#> $node$createdIndex
#> [1] 72
```

## Meta

* Please [report any issues or bugs](https://github.com/ropensci/etseed/issues).
* License: MIT
* Citation: execute `citation(package = 'etseed')`

[![ropensci_footer](http://ropensci.org/public_images/github_footer.png)](http://ropensci.org)
