# iucn base uri http://apiv3.iucnredlist.org/api/v3/
# iucn country list country/list
# iucn example token = 9bb4facb6d23f48efbf424bb05c0c1ef1cf6f468393bc745d42179ac4aca5fee
# Threeat classification scheme
# http://www.iucnredlist.org/technical-documents/classification-schemes/threats-classification-scheme
# Habitat classification scheme
# http://www.iucnredlist.org/technical-documents/classification-schemes/habitats-classification-scheme-ver3
# iucn red list api doc
# http://apiv3.iucnredlist.org/api/v3/docs



token <- "9bb4facb6d23f48efbf424bb05c0c1ef1cf6f468393bc745d42179ac4aca5fee"
uris <- list(
  base = "http://apiv3.iucnredlist.org/api/v3/",
  threat = "threats/species/name/",
  habitat = "habitats/species/name/",
  measures = "measures/species/name/",
  individual = "species/"
)

iucnv3.ha <- function(species, region = NULL, ncores = NULL, ...) {
  return(fetch(species, uris$habitat, region, ncores))
}

iucnv3.th <- function(species, region = NULL, ncores = NULL) {
  return(fetch(species, uris$threat, region, ncores))
}

fetch <- function(species, uri, region, ncores) {
  if (is.null(ncores) || ncores < 2) {
    return(fetchMultiple(species, uri, region))
  } else {
    return(fetchParallel(species, uri, region, ncores))
  }
}

createUri <- function(species, infoUri, region = NULL) {
  regionUri <- ""
  if (!is.null(region)) {
    regionUri <- paste("region/", region, sep = "")
  }
  return(URLencode(paste(uris$base, infoUri, species, regionUri, "?token=", token, sep = "")))
}

fetchResult <- function(uri) {
  res <- fromJSON(RCurl::getURI(uri))
  if (length(grepl(uri, uris$habitat)) > 0) {
    print("HABITATS")
    return(list(habitat = habitat(res)))
  } else if (length(grepl(uri, uris$threat)) > 0) {
    print("THREAT")
    return(list(threat = threat(res)))
  } else if (length(grepl(uri, uris$measures)) > 0) {
    print("MEASURES")
    return(list(measure = measure(res)))
  } else if (length(grepl(uri, uris$individual)) > 0) {
    print("SPECIES")
    return(list(species = species(res)))
  }
  print("DEFAULT")
  return(res)
}

fetchMultiple <- function(species, fetchUri, region = NULL) {
  result <- list()
  for (i in 1:length(species)) {
    uri <- createUri(species[i], fetchUri, region)
    res <- fetchResult(uri)
    result <- append(result, res)
  }
  return(result)
}

fetchParallel <- function(species, fetchUri, region = NULL, ncores) {

}

printProgress <- function() {
  # Ctrl+L effect
  cat("\014")
}
