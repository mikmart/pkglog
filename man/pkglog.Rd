% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/pkglog.R
\name{pkglog}
\alias{pkglog}
\alias{new_pkglog}
\title{Get the current package log}
\usage{
pkglog(path = ".")

new_pkglog(...)
}
\arguments{
\item{path}{folder to look for an existing log file for}

\item{...}{arguments passed to \code{sessioninfo::package_info()}}
}
\description{
\code{pkglog()} looks for an existing package log file: if found, it is read and
updated with currently loaded packages. \code{new_pkglog()} creates a new log from
currently loaded packages.
}
