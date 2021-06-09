# Copied from fundiversity::fd_chull & pavo::tcssum
fa_ahull <- function(traits, avalue) {

  traits <- traits[!duplicated(traits),, drop = FALSE]

  if (ncol(traits) == 1L) {
    return(list(
      "hull" = c(which.min(traits), which.max(traits)),
      "area" = max(traits) - min(traits),
      "vol" = max(traits) - min(traits),
      p = traits
    ))
  }

  if (nrow(traits) <= ncol(traits)) {
    return(list(
      "hull" = seq_len(nrow(traits)),
      "area" = NA_real_,
      "vol" = NA_real_,
      p = traits
    ))
  }

  if (avalue == "auto") {
    avalue <- find_astar(traits)
  }
  ashape <- alphashape3d::ashape3d(traits, avalue)

  return(list(
    "hull" = NA_real_,
    "area" = NA_real_,
    "vol" = alphashape3d::volume_ashape3d(ashape)
  ))

}
