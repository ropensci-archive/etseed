#' etseed client
#'
#' @export
#' @name etcd
#'
#' @param host (character) Host url. Deafault: 127.0.0.1
#' @param port (character/numeric) Port. Default: 2379
#' @param api_version (characrter) etcd API version. Default: 'v2'
#' @param allow_redirect (logical) Allow redirects? Default: \code{TRUE}
#' @param scheme (character) http scheme, one of http or https. Default: http
#'
#' @details \code{etcd} creates a R6 class object. The object is
#' not cloneable and is portable, so it can be inherited across packages
#' without complication.
#'
#' \code{etcd} is used to initialize a client that knows about your etcd
#' instance, with options for setting host, port, etcd api version,
#' whether to allow redirects, and the http scheme.
#'
#' @section etcd methods:
#' \strong{Methods}
#'   \describe{
#'     \item{\code{ping()}}{
#'      ping the etcd server
#'     }
#'     \item{\code{version()}}{
#'      check the etcd version
#'     }
#'     \item{\code{keys()}}{
#'      list keys
#'     }
#'     \item{\code{key()}}{
#'      get a key
#'     }
#'     \item{\code{create()}}{
#'      create a key
#'     }
#'     \item{\code{delete()}}{
#'      delete a key
#'     }
#'     \item{\code{update()}}{
#'      update a key
#'     }
#'     \item{\code{create_inorder()}}{
#'      create a key in order
#'     }
#'     \item{\code{metrics()}}{
#'      see metrics
#'     }
#'     \item{\code{stats()}}{
#'      see stats
#'     }
#'     \item{\code{user_add()}}{
#'      add a user
#'     }
#'     \item{\code{user_list()}}{
#'      list users
#'     }
#'     \item{\code{user_get()}}{
#'      get a user
#'     }
#'     \item{\code{user_delete()}}{
#'      delete a user
#'     }
#'     \item{\code{member_list()}}{
#'      list members
#'     }
#'     \item{\code{member_add()}}{
#'      add a member
#'     }
#'     \item{\code{member_change()}}{
#'      change a member
#'     }
#'     \item{\code{member_delete()}}{
#'      delete a member
#'     }
#'     \item{\code{role_add()}}{
#'      add a role
#'     }
#'     \item{\code{role_list()}}{
#'      list roles
#'     }
#'     \item{\code{role_get()}}{
#'      get a role
#'     }
#'     \item{\code{role_delete()}}{
#'      delete a role
#'     }
#'     \item{\code{auth_status()}}{
#'      authentication status
#'     }
#'     \item{\code{auth_enable()}}{
#'      enable authentication
#'     }
#'     \item{\code{auth_disable()}}{
#'      disable authentication
#'     }
#'   }
#'
#' @examples \dontrun{
#' # make a client
#' cli <- etcd()
#'
#' # ping
#' ## ping to make sure it's up
#' cli$ping()
#'
#' # version
#' ## get etcd version information
#' cli$version()
#'
#' # etcd variables
#' cli$host
#' cli$port
#' cli$api_version
#' cli$allow_redirect
#' cli$scheme
#'
#' # set a different host
#' etcd(host = 'stuff.com')
#'
#' # set a different port
#' etcd(host = 3456)
#'
#' # set a different etcd API version
#' etcd(host = 'v3')
#'
#' # set a different http scheme
#' etcd(scheme = 'https')
#'
#' # don't allow redirects
#' etcd(allow_redirects = FALSE)
#' }
etcd <- function(host = "127.0.0.1", port = 2379, api_version = 'v2',
                 allow_redirect = TRUE, scheme = 'http') {
  EtcdClient$new(host = host, port = port, api_version = api_version,
                 allow_redirect = allow_redirect, scheme = scheme)
}

#' @importFrom R6 R6Class
EtcdClient <- R6::R6Class(
  "EtcdClient",
  portable = TRUE,
  cloneable = FALSE,
  public = list(
    host = "127.0.0.1",
    port = 2379,
    api_version = 'v2',
    allow_redirect = TRUE,
    scheme = 'http',

    initialize = function(host, port, api_version, allow_redirect, scheme) {
      if (!missing(host)) self$host <- host
      if (!missing(port)) self$port <- port
      if (!missing(api_version)) self$api_version <- api_version
      if (!missing(allow_redirect)) self$allow_redirect <- allow_redirect
      if (!missing(scheme)) self$scheme <- scheme
    },

    print = function(...) {
      cat('<etcd client>', sep = "\n")
      cat(paste0('  host: ', self$host), sep = "\n")
      cat(paste0('  port: ', self$port), sep = "\n")
      cat(paste0('  api_version: ', self$api_version), sep = "\n")
      cat(paste0('  scheme: ', self$scheme), sep = "\n")
      cat(paste0('  allow redirect: ', self$allow_redirect), sep = "\n")
    },

    ping = function(...) self$version(...),

    version = function(...) {
      etcd_parse(
        etcd_GET(sub("v2", "version", private$make_url()), list(), ...)
      )
    },

    # keys
    keys = function(recursive = NULL, sorted = NULL, ...) {
      etcd_parse(
        etcd_GET(file.path(private$make_url(), "keys"),
                 etc(list(recursive = recursive, sorted = sorted)), ...)
      )
    },

    key = function(key, recursive = NULL, sorted = NULL, wait = FALSE, wait_index = NULL, ...) {
      etcd_parse(etcd_GET(sprintf("%s/%s%s", private$make_url(), "keys", check_key(key)),
                          etc(list(recursive = recursive, sorted = sorted,
                                   wait = asl(wait), waitIndex = wait_index)), ...))
    },

    create = function(key, value = NULL, file = NULL, ttl = NULL, dir = FALSE, ...) {
      etcd_parse(
        etcd_PUT(sprintf("%s/%s%s", private$make_url(), "keys", check_key(key)), value, ttl, dir, file, ...)
      )
    },

    delete = function(key, prevValue = NULL, prevIndex = NULL, dir = FALSE, recursive = NULL, ...) {
      etcd_parse(etcd_DELETE(sprintf("%s/%s%s", private$make_url(), "keys", check_key(key)),
                             etc(list(prevValue = prevValue, prevIndex = prevIndex, dir = dir,
                                      recursive = recursive)), ...))
    },

    update = function(key, value, ttl = NULL, ...) {
      etcd_parse(etcd_PUT(sprintf("%s/%s%s", private$make_url(), "keys", check_key(key)), value, ttl, ...))
    },

    create_inorder = function(key, value, ttl = NULL, ...) {
      etcd_parse(etcd_POST(sprintf("%s%s%s", private$make_url(), "keys", check_key(key)), value, ttl, ...))
    },

    # metrics
    metrics = function(pretty = TRUE, ...) {
      res <- etcd_GET(sub("v2", "metrics", private$make_url()), NULL, ...)
      if (pretty) {
        cat(res)
      } else {
        res
      }
    },

    # stats
    stats = function(which = "leader", pretty = TRUE, ...) {
      res <- etcd_GET(paste0(private$make_url(), "/stats/", which), NULL, ...)
      if (pretty) {
        jsonlite::fromJSON(res)
      } else {
        res
      }
    },

    # users
    user_add = function(user, password, auth_user = NULL, auth_pwd = NULL, roles = NULL, ...) {
      if (is.null(auth_user)) auth_user <- user
      if (is.null(auth_pwd)) auth_pwd <- password
      args <- etc(list(user = user, password = password, roles = roles))
      user_PUT(paste0(private$make_url(), paste0("/auth/users/", user)),
               body = args, make_auth(auth_user, auth_pwd), ...)
    },

    user_list = function(...) {
      res <- etcd_GET(paste0(private$make_url(), "/auth/users/"), NULL, ...)
      jsonlite::fromJSON(res)
    },

    user_get = function(user, ...) {
      res <- etcd_GET(paste0(private$make_url(), paste0("/auth/users/", user)), NULL, ...)
      jsonlite::fromJSON(res)
    },

    user_delete = function(user, auth_user, auth_pwd, ...) {
      invisible(etcd_DELETE(paste0(private$make_url(), paste0("/auth/users/", user)),
                            NULL, make_auth(auth_user, auth_pwd), ...))
    },

    # members
    member_list = function(...) {
      res <- etcd_GET(paste0(private$make_url(), "/members"), NULL, ...)
      jsonlite::fromJSON(res, FALSE)
    },

    member_add = function(id, ...) {
      res <- member_POST(paste0(private$make_url(), "/members"),
                         body = list(peerURLs = list(id)),
                         make_auth(Sys.getenv("ETSEED_USER"), Sys.getenv("ETSEED_PWD")), ...)
      jsonlite::fromJSON(res, FALSE)
    },

    member_change = function(id, newid, ...) {
      res <- member_PUT(paste0(private$make_url(), "/members/", id),
                        body = list(peerURLs = list(newid)),
                        make_auth(Sys.getenv("ETSEED_USER"), Sys.getenv("ETSEED_PWD")), ...)
      jsonlite::fromJSON(res, FALSE)
    },

    member_delete = function(id, ...) {
      res <- member_DELETE(paste0(private$make_url(), "/members/", id),
                           make_auth(Sys.getenv("ETSEED_USER"), Sys.getenv("ETSEED_PWD")), ...)
      identical(res, "")
    },

    # roles
    role_add = function(role, perm_read = NULL, perm_write = NULL,
                         grant_read = NULL, grant_write = NULL,
                         revoke_read = NULL, revoke_write = NULL,
                         auth_user, auth_pwd, ...) {

      args <- etc(list(role = role,
                       permissions = list(kv = list(read = perm_read, write = perm_write)),
                       grant = list(kv = list(read = grant_read, write = grant_write)),
                       revoke = list(kv = list(read = revoke_read, write = revoke_write))
      ))
      auth_PUT(paste0(private$make_url(), paste0("/auth/roles/", role)),
               body = args, make_auth(auth_user, auth_pwd), ...)
    },

    role_list = function(...) {
      res <- etcd_GET(paste0(private$make_url(), "/auth/roles/"), NULL, ...)
      jsonlite::fromJSON(res)
    },

    role_get = function(role, ...) {
      res <- etcd_GET(paste0(private$make_url(), paste0("/auth/roles/", role)), NULL, ...)
      jsonlite::fromJSON(res)
    },

    role_delete = function(role, auth_role, auth_pwd, ...) {
      invisible(auth_DELETE(paste0(private$make_url(), paste0("/auth/roles/", role)),
                            NULL, make_auth(auth_role, auth_pwd), ...))
    },

    # auth
    auth_status = function(...) {
      res <- etcd_GET(paste0(private$make_url(), "/auth/enable"), NULL, ...)
      jsonlite::fromJSON(res)
    },

    auth_enable = function(auth_user, auth_pwd, ...) {
      res <- auth_PUT(paste0(private$make_url(), "/auth/enable"), make_auth(auth_user, auth_pwd), ...)
      identical(res, "")
    },

    auth_disable = function(auth_user, auth_pwd, ...) {
      res <- auth_DELETE(paste0(private$make_url(), "/auth/enable"), NULL,
                         make_auth(auth_user, auth_pwd))
      identical(res, "")
    }

  ),

  private = list(
    make_url = function() {
      sprintf("%s://%s:%s/%s", self$scheme, self$host, self$port, self$api_version)
    }
  )
)
