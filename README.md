etseed
========



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
#> [1] 134
#> 
#> $node$createdIndex
#> [1] 134
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
#> [1] 136
#> 
#> $node$createdIndex
#> [1] 136
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
#> [1] "2015-02-06T14:53:56.549615442-08:00"
#> 
#> $node$ttl
#> [1] 5
#> 
#> $node$modifiedIndex
#> [1] 137
#> 
#> $node$createdIndex
#> [1] 137
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
#> [1] 139
#> 
#> $node$createdIndex
#> [1] 139
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
#> [1] 140
#> 
#> $node$createdIndex
#> [1] 140
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
#> [1] 139
#> 
#> $prevNode$createdIndex
#> [1] 139
```

## Create in-order keys


```r
create_inorder("queue", "thing1")
#> $action
#> [1] "create"
#> 
#> $node
#> $node$key
#> [1] "/queue/141"
#> 
#> $node$value
#> [1] "thing1"
#> 
#> $node$modifiedIndex
#> [1] 141
#> 
#> $node$createdIndex
#> [1] 141
```


```r
create_inorder("queue", "thing2")
#> $action
#> [1] "create"
#> 
#> $node
#> $node$key
#> [1] "/queue/142"
#> 
#> $node$value
#> [1] "thing2"
#> 
#> $node$modifiedIndex
#> [1] 142
#> 
#> $node$createdIndex
#> [1] 142
```


```r
create_inorder("queue", "thing3")
#> $action
#> [1] "create"
#> 
#> $node
#> $node$key
#> [1] "/queue/143"
#> 
#> $node$value
#> [1] "thing3"
#> 
#> $node$modifiedIndex
#> [1] 143
#> 
#> $node$createdIndex
#> [1] 143
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
#> [1] "/neighbor"
#> 
#> $node$nodes[[1]]$dir
#> [1] TRUE
#> 
#> $node$nodes[[1]]$modifiedIndex
#> [1] 134
#> 
#> $node$nodes[[1]]$createdIndex
#> [1] 134
#> 
#> 
#> $node$nodes[[2]]
#> $node$nodes[[2]]$key
#> [1] "/queue"
#> 
#> $node$nodes[[2]]$dir
#> [1] TRUE
#> 
#> $node$nodes[[2]]$modifiedIndex
#> [1] 8
#> 
#> $node$nodes[[2]]$createdIndex
#> [1] 8
#> 
#> 
#> $node$nodes[[3]]
#> $node$nodes[[3]]$key
#> [1] "/hello"
#> 
#> $node$nodes[[3]]$value
#> [1] ""
#> 
#> $node$nodes[[3]]$modifiedIndex
#> [1] 77
#> 
#> $node$nodes[[3]]$createdIndex
#> [1] 77
#> 
#> 
#> $node$nodes[[4]]
#> $node$nodes[[4]]$key
#> [1] "/gggg"
#> 
#> $node$nodes[[4]]$value
#> [1] "list(mpg = c(21, 21, 22.8, 21.4, 18.7, 18.1, 14.3, 24.4, 22.8, 19.2, 17.8, 16.4, 17.3, 15.2, 10.4, 10.4, 14.7, 32.4, 30.4, 33.9, 21.5, 15.5, 15.2, 13.3, 19.2, 27.3, 26, 30.4, 15.8, 19.7, 15, 21.4), cyl = c(6, 6, 4, 6, 8, 6, 8, 4, 4, 6, 6, 8, 8, 8, 8, 8, 8, 4, 4, 4, 4, 8, 8, 8, 8, 4, 4, 4, 8, 6, 8, 4), disp = c(160, 160, 108, 258, 360, 225, 360, 146.7, 140.8, 167.6, 167.6, 275.8, 275.8, 275.8, 472, 460, 440, 78.7, 75.7, 71.1, 120.1, 318, 304, 350, 400, 79, 120.3, 95.1, 351, 145, 301, 121), hp = c(110, \n110, 93, 110, 175, 105, 245, 62, 95, 123, 123, 180, 180, 180, 205, 215, 230, 66, 52, 65, 97, 150, 150, 245, 175, 66, 91, 113, 264, 175, 335, 109), drat = c(3.9, 3.9, 3.85, 3.08, 3.15, 2.76, 3.21, 3.69, 3.92, 3.92, 3.92, 3.07, 3.07, 3.07, 2.93, 3, 3.23, 4.08, 4.93, 4.22, 3.7, 2.76, 3.15, 3.73, 3.08, 4.08, 4.43, 3.77, 4.22, 3.62, 3.54, 4.11), wt = c(2.62, 2.875, 2.32, 3.215, 3.44, 3.46, 3.57, 3.19, 3.15, 3.44, 3.44, 4.07, 3.73, 3.78, 5.25, 5.424, 5.345, 2.2, 1.615, 1.835, 2.465, 3.52, 3.435, 3.84, \n3.845, 1.935, 2.14, 1.513, 3.17, 2.77, 3.57, 2.78), qsec = c(16.46, 17.02, 18.61, 19.44, 17.02, 20.22, 15.84, 20, 22.9, 18.3, 18.9, 17.4, 17.6, 18, 17.98, 17.82, 17.42, 19.47, 18.52, 19.9, 20.01, 16.87, 17.3, 15.41, 17.05, 18.9, 16.7, 16.9, 14.5, 15.5, 14.6, 18.6), vs = c(0, 0, 1, 1, 0, 1, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1), am = c(1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1), gear = c(4, 4, 4, 3, 3, 3, \n3, 4, 4, 4, 4, 3, 3, 3, 3, 3, 3, 4, 4, 4, 3, 3, 3, 3, 3, 4, 5, 5, 5, 5, 5, 4), carb = c(4, 4, 1, 1, 2, 1, 4, 2, 2, 4, 4, 3, 3, 3, 4, 4, 4, 1, 2, 1, 1, 2, 2, 4, 2, 1, 2, 2, 4, 6, 8, 2))"
#> 
#> $node$nodes[[4]]$modifiedIndex
#> [1] 103
#> 
#> $node$nodes[[4]]$createdIndex
#> [1] 103
#> 
#> 
#> $node$nodes[[5]]
#> $node$nodes[[5]]$key
#> [1] "/stuff"
#> 
#> $node$nodes[[5]]$value
#> [1] "tables"
#> 
#> $node$nodes[[5]]$expiration
#> [1] "2015-02-06T14:53:56.549615442-08:00"
#> 
#> $node$nodes[[5]]$ttl
#> [1] 5
#> 
#> $node$nodes[[5]]$modifiedIndex
#> [1] 137
#> 
#> $node$nodes[[5]]$createdIndex
#> [1] 137
#> 
#> 
#> $node$nodes[[6]]
#> $node$nodes[[6]]$key
#> [1] "/mykey"
#> 
#> $node$nodes[[6]]$value
#> [1] "this is awesome"
#> 
#> $node$nodes[[6]]$modifiedIndex
#> [1] 136
#> 
#> $node$nodes[[6]]$createdIndex
#> [1] 136
#> 
#> 
#> $node$nodes[[7]]
#> $node$nodes[[7]]$key
#> [1] "/foo"
#> 
#> $node$nodes[[7]]$value
#> [1] "bar stool"
#> 
#> $node$nodes[[7]]$modifiedIndex
#> [1] 140
#> 
#> $node$nodes[[7]]$createdIndex
#> [1] 140
#> 
#> 
#> $node$nodes[[8]]
#> $node$nodes[[8]]$key
#> [1] "/message"
#> 
#> $node$nodes[[8]]$value
#> [1] "Hello etcd"
#> 
#> $node$nodes[[8]]$modifiedIndex
#> [1] 67
#> 
#> $node$nodes[[8]]$createdIndex
#> [1] 67
#> 
#> 
#> $node$nodes[[9]]
#> $node$nodes[[9]]$key
#> [1] "/ttt"
#> 
#> $node$nodes[[9]]$value
#> [1] "Hello etcd"
#> 
#> $node$nodes[[9]]$modifiedIndex
#> [1] 100
#> 
#> $node$nodes[[9]]$createdIndex
#> [1] 100
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
#> [1] 136
#> 
#> $node$createdIndex
#> [1] 136
```

## Meta

* Please report any issues or bugs](https://github.com/ropensci/etseed/issues).
* License: MIT
* Citation: execute `citation(package = 'etseed')`

[![ropensci_footer](http://ropensci.org/public_images/github_footer.png)](http://ropensci.org)
