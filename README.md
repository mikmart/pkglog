# pkglog

Experimental package to save lightweight log files of loaded packages. Aims to
improve reproducibility without heavy operations such as reinstalling packages.

## Usage

**pkglog** works on a log file called `pkglog.csv` in your working directory.
The log file is a persistent, time-stamped copy of `sessioninfo::package_info()`
saved as a csv file.

``` r
library(pkglog)

# enable automatic logging on exit
pkglog_enable()

# read an existing log file
pkglog_read()

# get an up-to-date log including current packages
pkglog() 

# write the current log file to disk
pkglog_write(pkglog())
```
