.onAttach <- function(...) {
  pkglog_disable()

  # hook that runs on session exit or package unload
  reg.finalizer(pkglog_opts, function(opts) {
    if (!opts$disable) {
      pkglog_write()
    }
  }, onexit = TRUE)
}
