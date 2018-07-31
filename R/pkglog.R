pkglog_env <- new.env()

#' Runs at package detach or session exit
#' @param e pkglog_env passed on exit
pkglog_exit_hook <- function(e) {
  if (!pkglog_env$disable) {
    pkglog_write(pkglog())
  }
}

#' Write the current package log to a file
#' @param x a package log `data.frame` to be written
#' @param path folder that the log file `pkglog.csv` is written to
#' @importFrom utils write.table
#' @export
pkglog_write <- function(x = pkglog(), path = ".") {
  tf <- tempfile("pkglog-", fileext = ".csv")
  on.exit(unlink(tf))

  utils::write.csv(x, file = tf, row.names = FALSE)
  file.copy(tf, to = pkglog_file(path), overwrite = TRUE)
}

#' Get the current package log
#'
#' `pkglog()` looks for an existing package log file: if found, it is read and
#' updated with currently loaded packages. `new_pkglog()` creates a new log from
#' currently loaded packages.
#'
#' @param path folder to look for an existing log file for
#' @export
pkglog <- function(path = ".") {
  if (!has_pkglog(path)) {
    return(new_pkglog())
  }

  log <- pkglog_read(path)
  pkglog_update(log)
}

pkglog_file <- function(path = ".") {
  file.path(path, "pkglog.csv")
}

#' Does the folder contain a package log file?
#' @param path folder to check for a package log
#' @export
has_pkglog <- function(path = ".") {
  file.exists(pkglog_file(path))
}

#' @param ... arguments passed to `sessioninfo::package_info()`
#' @rdname pkglog
#' @export
new_pkglog <- function(...) {
  stamp(sessioninfo::package_info(...))
}

stamp <- function(x) {
  x$last_loaded <- Sys.time()
  x
}

#' Read a package log file
#' @param path folder containing a `pkglog.csv`
#' @export
pkglog_read <- function(path = ".") {
  utils::read.csv(pkglog_file(path), stringsAsFactors = FALSE)
}

pkglog_update <- function(x) {
  current <- new_pkglog()
  is_prior <- !x$package %in% current$package
  rbind(current, x[is_prior, ])
}

#' Remove a package log file
#' @param path folder to remove `pkglog.csv` from
#' @export
pkglog_clear <- function(path = ".") {
  unlink(pkglog_file(path))
}

#' Enable/disable automatic logging on exit
#' @name pkglog-toggle
NULL

#' @describeIn pkglog-toggle Disable logging
#' @export
pkglog_disable <- function() {
  pkglog_env$disable <- TRUE
}

#' @describeIn pkglog-toggle Enable logging
#' @export
pkglog_enable <- function() {
  pkglog_env$disable <- FALSE
}
