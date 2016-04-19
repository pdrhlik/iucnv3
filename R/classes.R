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
  result <- data$result
  ret <- list(
    name = data$name,
    code = result$code,
    title = result$title,
    timing = result$timing,
    scope = result$scope,
    severity = result$severity,
    score = result$score
  )
  class(ret) <- append(class(ret), "threat")
  return(ret)
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
