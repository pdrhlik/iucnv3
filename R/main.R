# iucn base uri http://apiv3.iucnredlist.org/api/v3/
# iucn country list country/list
# iucn example token = 9bb4facb6d23f48efbf424bb05c0c1ef1cf6f468393bc745d42179ac4aca5fee
# Threeat classification scheme
# http://www.iucnredlist.org/technical-documents/classification-schemes/threats-classification-scheme
# Habitat classification scheme
# http://www.iucnredlist.org/technical-documents/classification-schemes/habitats-classification-scheme-ver3
# iucn red list api doc
# http://apiv3.iucnredlist.org/api/v3/docs

baseUri <- "http://apiv3.iucnredlist.org/api/v3/"
threatUri <- "threats/species/name/"
habitatUri <- "habitats/species/name/"
measuresUri <- "measures/species/name/"
individualUri <- "species/"
token <- "9bb4facb6d23f48efbf424bb05c0c1ef1cf6f468393bc745d42179ac4aca5fee"

library(utils)
library(RCurl)
library(jsonlite)

#'
#'
createUri <- function(species, infoUri, region = NULL) {
  regionUri <- ""
  if (!is.null(region)) {
    regionUri <- paste("region/", region, sep = "")
  }
  return(URLencode(paste(baseUri, infoUri, species, regionUri, "?token=", token, sep = "")))
}

threatsBySpecies <- function(species) {

}

habitatsBySpecies <- function(species) {

}

fetchResult <- function(uri) {
  return(fromJSON(RCurl::getURI(uri)))
}

fetchMultiple <- function(species, infoUri, region = NULL) {
  result <- list()
  for (i in 1:length(species)) {
    uri <- createUri(species[i], infoUri, region)
    res <- fetchResult(uri)
    result <- append(result, list(species = species(res)))
  }
  return(result)
}

#' IUCN Red List habitat class definition
habitat <- function(data, ...) {
  result <- data$result
  ret <- list(
    name = data$name,
    code = result$code,
    habitat = result$habitat,
    suitability = result$suitability,
    season = result$season,
    majorimportance = result$majorimportance
  )
  class(ret) <- append(class(ret), "habitat")
  return(ret)
}

#' IUCN Red List conservation measure class definition
measure <- function(data, ...) {
  result <- data$result
  ret <- list(
    name = data$name,
    code = result$code,
    title = result$title
  )
  class(ret) <- append(class(ret), "measure")
  return(ret)
}

#' IUCN Red List species threat class definition
threat <- function(data, ...) {

}

#' IUCN Red List individual species information class definition
species <- function(data, ...) {
  result <- data$result
  ret <- list(
    name = data$name,
    taxonid = result$taxonid,
    scientific_name = result$scientific_name,
    kingdom = result$kingdom,
    phylum = result$phylum,
    class = result$class,
    order = result$order,
    family = result$family,
    genus = result$genus,
    main_common_name = result$main_common_name,
    authority = result$authority,
    published_year = result$published_year,
    category = result$category,
    criteria = result$criteria,
    marine_system = result$marine_system,
    freshwater_system = result$freshwater_system,
    terrestrial_system = result$terrestrial_system,
    assessor = result$assessor,
    reviewer = result$reviewer
  )
  class(ret) <- append(class(ret), "species")
  return(ret)
}








