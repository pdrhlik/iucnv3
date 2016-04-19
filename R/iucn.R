# library(letsR)
# library(parallel)
# spNamesDf <- read.csv("speciesV8.csv")
# spNamesVec <- levels(spNamesDf$SpeciesRedListV8)
#
# ncores <- 7
# part <- 50
# start <- 2451
# sps <- spNamesVec[start:(start + (ncores * part) - 1)]
# n <- length(sps)
#
# system.time({
#   parData2101_2450 <- mclapply(1:ncores, function(i) {
#     from <- (i - 1) * part + 1
#     to <- from + part - 1
#     lets.iucn(sps[from:to])
#   }, mc.cores = ncores)
# })
#
#
#
# for (i in 1:1) {
#   ncores <- 5
#   part <- 10
#   start <- 1 + (i - 1) * (ncores * part)
#   end <- start + (ncores * part) - 1
#   sps <- a[start:end]
#   n <- length(sps)
#   print(cat("DOWNLOADING", start, "to", end, "\n"))
#   print(system.time({
#     arr <- mclapply(1:ncores, function(j) {
#       from <- (j - 1) * part + 1
#       to <- from + part - 1
#       lets.iucn.his(sps[from:to])
#     }, mc.cores = ncores)
#     if (length(arr) > 1) {
#       conservationLast <- append(conservationLast, arr)
#     } else {
#       print("F*** errors.")
#     }
#   }))
# }
#
# # save list to a csv file
# lapply(completeArray, write.table, "iucn1.csv", append=TRUE, col.names = FALSE, row.names = FALSE, sep = ",")
#
#
#
# completeConservation <- append(consNoError, consSecondCons)
# lapply(completeConservation, write.table, "iucn_complete_conservation.csv", append=TRUE, col.names = FALSE, row.names = FALSE, sep = ",")
#
# elCount <- function(ls) {
#   cnt <- 0
#   cntBad <- 0
#   for (l in ls) {
#     if (length(l) > 1) {
#       cnt <- cnt + length(l$Species)
#     } else {
#       cntBad <- cntBad + 1
#       print(l$message)
#     }
#   }
#   print(cntBad)
#   return(cnt)
# }
#
# species <- list()
# for (spec in a) {
#   sp <- NULL
#   tryCatch({
#     sp <- lets.iucn.his(spec)
#     print(spec)
#     species <- rbind(species, sp)
#   }, error = function(e) {
#     print(cat("error:", spec))
#   })
# }
#
#
# write.csv(data, "iucn-data.csv", row.names = FALSE)
#
#
# lapply(consNoError, write.csv, file = "test-cons.csv", append = TRUE)
#
#
# for (l in conservationSecond) {
#   write.table(l$Species, file = "test-cons-sec.csv", append = TRUE, col.names = FALSE, row.names = FALSE)
# }
#
#
