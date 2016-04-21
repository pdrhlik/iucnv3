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

prepareResultMatrix <- function(size, uri) {
	header <- NULL
	ncols <- 0
	if (grepl(uris$habitat, uri)) {
		header <- habitatHeader
		ncols <- HABITAT_LENGTH + 1
	} else if (grepl(uris$history, uri)) {
		header <- c("Species", seq(YEAR_FROM, YEAR_TO))
		ncols <- length(header)
	} else if (grepl(uris$individual, uri)) {
		header <- speciesHeader
		ncols <- SPECIES_LENGTH
	}
	mat <- matrix(NA, size, ncols)
	colnames(mat) <- header
	return(mat)
}

fetchResult <- function(uri) {
	res <- fromJSON(RCurl::getURI(uri))
	print(res)
	if (grepl(uris$habitat, uri)) {
		print("HABITAT")
		return(prepare.ha(res))
	} else if (grepl(uris$history, uri)) {
		print("HISTORY")
		return(prepare.his(res))
	} else if (grepl(uris$individual, uri)) {
		print("INDI")
		return(prepare.sp(res))
	}
	print("DEFAULT")
	return(res)
}

fetchMultiple <- function(species, fetchUri, region = NULL) {
	result <- prepareResultMatrix(length(species), fetchUri)
	for (i in 1:length(species)) {
		uri <- createUri(species[i], fetchUri, region)
		res <- fetchResult(uri)
		result[i, ] <- res
	}
	return(data.frame(result))
}

fetchParallel <- function(species, fetchUri, region = NULL, ncores) {

}

printProgress <- function() {
  # Ctrl+L effect
  cat("\014")
}
