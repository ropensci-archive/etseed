etseed
========



__etcd R client__

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


```
#> $action
#> [1] "delete"
#> 
#> $node
#> $node$key
#> [1] "/neighbor"
#> 
#> $node$dir
#> [1] TRUE
#> 
#> $node$modifiedIndex
#> [1] 61
#> 
#> $node$createdIndex
#> [1] 54
#> 
#> 
#> $prevNode
#> $prevNode$key
#> [1] "/neighbor"
#> 
#> $prevNode$dir
#> [1] TRUE
#> 
#> $prevNode$modifiedIndex
#> [1] 54
#> 
#> $prevNode$createdIndex
#> [1] 54
```


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
#> [1] 62
#> 
#> $node$createdIndex
#> [1] 62
```

## Create a key


```
#> $action
#> [1] "delete"
#> 
#> $node
#> $node$key
#> [1] "/mykey"
#> 
#> $node$modifiedIndex
#> [1] 63
#> 
#> $node$createdIndex
#> [1] 56
#> 
#> 
#> $prevNode
#> $prevNode$key
#> [1] "/mykey"
#> 
#> $prevNode$value
#> [1] ""
#> 
#> $prevNode$modifiedIndex
#> [1] 56
#> 
#> $prevNode$createdIndex
#> [1] 56
```


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
#> [1] ""
#> 
#> $node$modifiedIndex
#> [1] 64
#> 
#> $node$createdIndex
#> [1] 64
```

Use `ttl` parameter to make it dissappear after `x` seconds


```r
create(key="stuff", value="tables", ttl=5)
#> Error in etcd_PUT(sprintf("%s%s/%s/", etcdbase(), "keys", key), value, : client error: (400) Bad Request
```

And the key will be gone after 5 seconds, see:


```r
key("stuff")
#> Error in etcd_GET(sprintf("%s%s/%s/", etcdbase(), "keys", key), ...) : 
#>   client error: (404) Not Found 
```

## Update a key


```
#> $action
#> [1] "delete"
#> 
#> $node
#> $node$key
#> [1] "/foo"
#> 
#> $node$modifiedIndex
#> [1] 65
#> 
#> $node$createdIndex
#> [1] 58
#> 
#> 
#> $prevNode
#> $prevNode$key
#> [1] "/foo"
#> 
#> $prevNode$value
#> [1] ""
#> 
#> $prevNode$modifiedIndex
#> [1] 58
#> 
#> $prevNode$createdIndex
#> [1] 58
```

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
#> [1] ""
#> 
#> $node$modifiedIndex
#> [1] 66
#> 
#> $node$createdIndex
#> [1] 66
```

The update the key


```r
update(key="foo", value="bar stool")
#> Error in etcd_PUT(sprintf("%s%s/%s/", etcdbase(), "keys", key), value, : client error: (400) Bad Request
```

## Create in-order keys


```
#> $errorCode
#> [1] 102
#> 
#> $message
#> [1] "Not a file"
#> 
#> $cause
#> [1] "/queue"
#> 
#> $index
#> [1] 66
```


```r
create_inorder("queue", "thing1")
#> $action
#> [1] "create"
#> 
#> $node
#> $node$key
#> [1] "/queue/67"
#> 
#> $node$value
#> [1] ""
#> 
#> $node$modifiedIndex
#> [1] 67
#> 
#> $node$createdIndex
#> [1] 67
create_inorder("queue", "thing2")
#> Error in etcd_POST(sprintf("%s%s/%s/", etcdbase(), "keys", key), value, : client error: (400) Bad Request
create_inorder("queue", "thing3")
#> $action
#> [1] "create"
#> 
#> $node
#> $node$key
#> [1] "/queue/68"
#> 
#> $node$value
#> [1] ""
#> 
#> $node$modifiedIndex
#> [1] 68
#> 
#> $node$createdIndex
#> [1] 68
```

## List keys


```r
keys()
#> Error in etcd_GET(sprintf("%s%s/", etcdbase(), "keys"), etc(list(recursive = recursive, : client error: (400) Bad Request
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
#> [1] ""
#> 
#> $node$modifiedIndex
#> [1] 64
#> 
#> $node$createdIndex
#> [1] 64
```

## Meta

* Please report any issues or bugs](https://github.com/ropensci/etseed/issues).
* License: MIT
* Citation: execute `citation(package = 'etseed')`

[![ropensci_footer](http://ropensci.org/public_images/github_footer.png)](http://ropensci.org)
