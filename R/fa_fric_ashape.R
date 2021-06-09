# Copied from fundiversity

#' Compute Functional Richness (FRic) with
#' \ifelse{html}{\out{&alpha;}}{\eqn{$\alpha$}{alpha}}-shape
#'
#' Functional Richness is computed as the volume of the
#' \ifelse{html}{\out{&alpha;}}{\eqn{$\alpha$}{alpha}}-shape from all
#' included traits.
#'
#' @inheritParams fundiversity::fd_fric
#' @param avalue The value of the
#' \ifelse{html}{\out{&alpha;}}{\eqn{$\alpha$}{alpha}} parameter to compute the
#' \ifelse{html}{\out{&alpha;}}{\eqn{$\alpha$}{alpha}}-shape.
#' Set to `"auto"` (the default) to get the
#' \ifelse{html}{\out{&alpha;*}}{\eqn{$\alpha^*$}{alpha*}} value as defined in
#' Gruson (2020).
#'
#' @inherit fundiversity::fd_fric return
#'
#' @inheritSection fundiversity::fd_fric Parallelization

#' @examples
#' data(traits_birds, package = "fundiversity")
#' fa_fric_ashape(traits_birds[,-1])

#' @export
#'
#' @importFrom future.apply future_apply
#'
#' @references
#' Gruson H. 2020. Estimation of colour volumes as concave hypervolumes using
#'  \ifelse{html}{\out{&alpha;}}{\eqn{$\alpha$}{alpha}}-shapes. Methods in
#'  Ecology and Evolution, early view \doi{10.1111/2041-210X.13398}
fa_fric_ashape <- function(traits, sp_com, stand = FALSE, avalue = "auto") {

  if (missing(traits) | is.null(traits)) {
    stop("Please provide a trait dataset", call. = FALSE)
  }

  if (is.data.frame(traits) | is.vector(traits)) {
    traits <- as.matrix(traits)
  }

  if (ncol(traits) != 3) {
    stop("Computing FRic with alpha-shapes is only implemented with traits
         datasets with 3 columns at the moment", call. = FALSE)
  }

  traits <- fundiversity:::remove_species_without_trait(traits)

  if (!missing(sp_com)) {

    common_species <- fundiversity:::species_in_common(traits, sp_com)

    traits <- traits[common_species,, drop = FALSE]
    sp_com <- sp_com[, common_species, drop = FALSE]


  } else {

    sp_com <- matrix(1, ncol = nrow(traits),
                     dimnames = list("s1", rownames(traits)))

  }

  max_range <- 1

  if (stand) {
    max_range <- fa_ahull(traits, avalue)$vol
  }

  fric_site <- future_apply(sp_com, 1, function(site_row) {
    fa_ahull(traits[site_row > 0,, drop = FALSE], avalue)$vol
  }, future.seed = TRUE)

  data.frame(site = rownames(sp_com), FRic = fric_site/max_range,
             row.names = NULL)
}
