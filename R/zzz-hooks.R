.onAttach <- function(...) {
  pkglog_disable()
  reg.finalizer(pkglog_env, pkglog_exit_hook, onexit = TRUE)
}
