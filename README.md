# pkglog

Experimental package to save lightweight log files of loaded packages. Aims to
improve reproducibility without heavy operations such as reinstalling packages.

## Usage

Simpy load **pkglog** and a log file of loaded packages called `pkglog.csv` will
be saved in your working directory when you exit your R session or detach the
package. The log file is a persistent, time-stamped copy of
`sessioninfo::package_info()` saved as a csv file..

``` r
library(pkglog)
```
