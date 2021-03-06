% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/auth.R
\name{auth}
\alias{auth}
\alias{auth_status}
\alias{auth_enable}
\alias{auth_disable}
\title{etcd authentication - auth control}
\arguments{
\item{auth_user, auth_pwd}{(character) Username and password for the
authenticated user, the root user}

\item{...}{Further args passed on to \code{\link[httr]{GET}},
\code{\link[httr]{PUT}}, or \code{\link[httr]{DELETE}}}
}
\value{
see return for each method
}
\description{
etcd authentication - auth control
}
\section{Methods}{

\itemize{
 \item auth_status: get authentication status, returns single boolean,
 \code{TRUE} indicates authentication enabled, and \code{FALSE}
 authentication disabled
 \item auth_enable: enable authentication, returns single boolean,
 \code{TRUE} indicates authentication enable request worked
 \item auth_disable: disable authentication, returns single boolean,
 \code{TRUE} indicates authentication disable request worked
}
}

\examples{
\dontrun{
# make a client
cli <- etcd()

# check authentication status
cli$auth_status()

# enable authentication
cli$auth_enable("root", "pickbetterpwd")

# woops, if you got error about root user, craeate one first
cli$user_add(user = "root", password = "pickbetterpwd")

# disable authentication
cli$auth_disable("root", "pickbetterpwd")

# check again, now disabled
cli$auth_status()

# Users
# Add user
cli$user_add("jane", "janepwd", "root", "pickbetterpwd")
# List users
cli$user_list()
# Get a single user
cli$user_get("root")
cli$user_get("jane")
# Delete user
cli$user_delete("jane", "root", "pickbetterpwd")
}
}
