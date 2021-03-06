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

#' @param ... arguments passed to `sessioninfo::package_info()`
#' @rdname pkglog
#' @export
new_pkglog <- function(...) {
  packages <- sessioninfo::package_info(...)
  stamp(as.data.frame(packages))
}

stamp <- function(x) {
  x$last_loaded <- Sys.time()
  x
}

#' Does the folder contain a package log file?
#' @param path folder to check for a package log
#' @export
has_pkglog <- function(path = ".") {
  file.exists(pkglog_file(path))
}

pkglog_file <- function(path = ".") {
  file.path(path, "pkglog.csv")
}

#' Read a package log file
#' @param path folder containing a `pkglog.csv`
#' @export
pkglog_read <- function(path = ".") {
  if (!has_pkglog(path)) {
    stop("`path` must have a ",
         basename(pkglog_file()), " file.\n",
         path, " does not.", call. = FALSE)
  }
  validate_log(utils::read.csv(
    pkglog_file(path),
    skip = 1L,
    stringsAsFactors = FALSE
  ))
}

validate_log <- function(x) {
  template <- new_pkglog()

  stopifnot(ncol(x) == ncol(template))
  stopifnot(all(names(x) == names(template)))

  x
}

pkglog_update <- function(x) {
  current <- new_pkglog()
  prior <- x[!x$package %in% current$package, ]

  stopifnot(ncol(current) == ncol(prior))
  rbind(current, prior)
}

#' Write the current package log to a file
#' @param x a package log `data.frame` to be written
#' @param path folder that the log file `pkglog.csv` is written to
#' @importFrom utils write.table
#' @export
pkglog_write <- function(x = pkglog(), path = ".") {
  tf <- tempfile("pkglog-", fileext = ".csv")
  on.exit(unlink(tf))

  write_csv(pkglog_message(), file = tf, col.names = FALSE)
  suppressWarnings(write_csv(x, file = tf, append = TRUE))

  file.copy(tf, to = pkglog_file(path), overwrite = TRUE)
}

write_csv <- function(...) {
  utils::write.table(sep = ",", row.names = FALSE, ...)
}

pkglog_message <- function() {
  version <- utils::packageVersion("pkglog")
  link <- "https://github.com/mikmart/pkglog"
  paste0(
    "# Generated by pkglog v. ", version, " (", link, ").",
    " Do not edit by hand."
  )
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
  pkglog_opts$disable <- TRUE
}

#' @describeIn pkglog-toggle Enable logging
#' @export
pkglog_enable <- function() {
  pkglog_opts$disable <- FALSE
}

pkglog_opts <- new.env()
