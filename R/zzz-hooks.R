.onAttach <- function(...) {
  pkglog_enable()
  reg.finalizer(pkglog_env, pkglog_exit_hook, onexit = TRUE)
}
