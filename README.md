
<!-- README.md is generated from README.Rmd. Please edit that file -->

# funalpha

<!-- badges: start -->
<!-- badges: end -->

This package provides an interface inspired from the
[fundiversity](https://cran.r-project.org/package=fundiversity) package
to compute functional richness with alpha-shapes as described in [Gruson
(2020)](https://doi.org/10.1111/2041-210X.13398).

## Installation

You can the latest version of this package from GitHub with:

``` r
# install.packages("remotes")
remotes::install_github("bisaloo/funalpha")
```

## Usage

``` r
library(funalpha)
data("traits_birds", package = "fundiversity")

fa_fric_ashape(traits_birds[, -1])
#> 'avalue' automatically set to 6.6384e+04
#>   site     FRic
#> 1   s1 9450.043
```
