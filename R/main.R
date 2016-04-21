token <- "9bb4facb6d23f48efbf424bb05c0c1ef1cf6f468393bc745d42179ac4aca5fee"
uris <- list(
  base = "http://apiv3.iucnredlist.org/api/v3/",
  threat = "threats/species/name/",
  habitat = "habitats/species/name/",
  measures = "measures/species/name/",
  history = "species/history/name/",
  individual = "species/"
)

iucnv3.ha <- function(species, region = NULL, ncores = NULL, ...) {
	return(fetch(species, uris$habitat, region, ncores))
}

iucnv3.his <- function(species, yearFrom = 1980, yearTo = getCurrentYear(), region = NULL, ncores = NULL) {
	YEAR_FROM = yearFrom
	YEAR_TO = yearTo
	return(fetch(species, uris$history, region, ncores))
}

iucnv3.sp <- function(species, region = NULL, ncores = NULL) {
  return(fetch(species, uris$individual, region, ncores))
}
