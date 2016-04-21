habitats <- c(
	"Forest",
	"Savanna",
	"Shrubland",
	"Grassland",
	"Wetlands (inland)",
	"Rocky Areas",
	"Caves and Subterranean Habitats",
	"Desert",
	"Marine Neritic",
	"Marine Oceanic",
	"Marine Deep Ocean Floor",
	"Marine Intertidal",
	"Marine Coastal/Supratidal",
	"Artificial/Terrestrial",
	"Artificial/Aquatic",
	"Introduced Vegetation",
	"Other",
	"Unknown"
)

habitatHeader <- c(
	"Species",
	habitats
)

speciesHeader <- c(
	"Species",
	"Family",
	"Status",
	"Criteria",
	"Description Year"
)

HABITAT_LENGTH = 18
SPECIES_LENGTH = 5
YEAR_FROM = 1980
YEAR_TO = getCurrentYear()

getCurrentYear <- function() {
	return(as.integer(format(Sys.Date(), "%Y")))
}

#' Returns a vector of 0/1 specifying if certain species
#' live in a certatin habitat. Only first level classification
#' schemes from IUCN Red List website are considered.
getHabitatVecByCode <- function(codes) {
	if (is.null(codes) || is.na(codes) || length(codes) == 0) {
		return(rep(NA, HABITAT_LENGTH))
	}
	ret <- rep(0, HABITAT_LENGTH)
	m <- regexpr("^[0-9]{1,2}", codes, perl = TRUE)
	matches <- as.integer(regmatches(codes, m))
	matches[matches > HABITAT_LENGTH] <- NA
	ret[matches] <- 1
	return(ret)
}

fixStatusCode <- function(code) {
	if (code == "E") {
		return("EN")
	} else if (code == "V") {
		return("VU")
	}
}

#' Prepares a vector from habitat results.
prepare.ha <- function(habitatResults) {
	hvec <- getHabitatVecByCode(habitatResults$result$code)
	return(c(habitatResults$name, hvec))
}

#' Prepares a vector from species results.
prepare.sp <- function(speciesResults) {
	if (length(speciesResults$result) == 0) {
		return(c(speciesResults$name, rep(NA, SPECIES_LENGTH - 1)))
	}
	res <- c(
		speciesResults$name,
		speciesResults$result$family,
		speciesResults$result$category,
		speciesResults$result$criteria,
		speciesResults$result$published_year
	)
	return(res)
}

prepare.his <- function(historyResult) {
	result <- historyResult$result
	if (length(result) == 0) {
		return(c(historyResult$name, rep(NA, YEAR_TO - YEAR_FROM + 1)))
	}
	result$year <- as.integer(result$year)
	index <- 1
	res <- rep(NA, length(seq(YEAR_FROM, YEAR_TO)))

	if (length(result$year) > 1) {
		firstYear <- result$year[length(result$year)]
		lastYear <- result$year[1]
		years <- rep(NA, lastYear - firstYear + 1)

		for (i in length(result$year):2) {
			year <- result$year[i]
			yearNext <- result$year[i - 1]

			indexTo <- index + yearNext - year - 1
			years[index:indexTo] <- result$code[i]
			index <- indexTo + 1
		}
		years[length(years)] <- result$code[i - 1]

		cat("First year:", firstYear, "\n")
		cat("Last year:", lastYear, "\n")
		cat("Year FROM:", YEAR_FROM, "\n")
		cat("Year TO:", YEAR_TO, "\n")
		cat("Year FROM - firstYear:", YEAR_FROM - firstYear, "\n")
		cat("Year TO - lastYear:", YEAR_TO - lastYear, "\n")
		cat("RESULT LENGTH:", length(res), "\n")

		if (YEAR_FROM < firstYear && YEAR_TO > lastYear) {
			print("SCENARIO 1")
			from <- firstYear - YEAR_FROM + 1
			to <- from + length(years) - 1
			res[from:to] <- years
			res[(to + 1):length(res)] <- result$code[i - 1]
		} else if (YEAR_FROM > firstYear && YEAR_TO > lastYear) {
			print("SCENARIO 2")
			years <- years[(YEAR_FROM - firstYear + 1):(length(years) - (YEAR_FROM - firstYear))]
			from <- 1
			to <- from + length(years) - 1
			res[from:to] <- years
			res[(to + 1):length(res)] <- result$code[i - 1]
		} else if (YEAR_FROM < firstYear && YEAR_TO < lastYear) {
			print("SCENARIO 3")
			years <- years[1:(length(years) - (lastYear - YEAR_TO))]
			from <- firstYear - YEAR_FROM + 1
			to <- from + length(years) - 1
			res[from:to] <- years
		} else if (YEAR_FROM > firstYear && YEAR_TO < lastYear) {
			print("SCENARIO 4")
			years <- years[(YEAR_FROM - firstYear + 1):(length(years) - (lastYear - YEAR_TO))]
			res <- years
		}
	} else {
		print("ONLY ONE YEAR")
	}

	return(c(historyResult$name, res))
}
