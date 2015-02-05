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
#> Error in eval(expr, envir, enclos): could not find function "version"
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
#> [1] "/mykey"
#> 
#> $node$nodes[[1]]$value
#> [1] "this is awesome"
#> 
#> $node$nodes[[1]]$modifiedIndex
#> [1] 3
#> 
#> $node$nodes[[1]]$createdIndex
#> [1] 3
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
#> [1] 3
#> 
#> $node$createdIndex
#> [1] 3
```

## Meta

* Please report any issues or bugs](https://github.com/ropensci/etseed/issues).
* License: MIT
* Citation: execute `citation(package = 'etseed')`

[![ropensci_footer](http://ropensci.org/public_images/github_footer.png)](http://ropensci.org)
