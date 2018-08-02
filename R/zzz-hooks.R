.onAttach <- function(...) {
  pkglog_enable()

  # hook that runs on session exit or package unload
  reg.finalizer(pkglog_opts, function(opts) {
    if (!opts$disable) {
      pkglog_write()
    }
  }, onexit = TRUE)
}
