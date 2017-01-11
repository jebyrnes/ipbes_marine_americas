###### Load libraries
library(robis)
library(dplyr)
library(purrr)
library(parallel)

#Load Spalding's marine Ecoregions of the world
#install_github("jebyrnes/meowR")
library(meowR)
data(regions)

#### Subset down to the ecoregions of the Americas
americas <- c(53:58, 14, 13, 12, 11, 9, 10, 7, 8, 11, 5, 37:43, 59:61, 62:77, 152, 163:189)

americas_regions <- subset(regions, regions$ECO_CODE_X %in% americas)

plot(americas_regions)


###### Get checklist for each area
#check_data <- checklist(geometry = writeWKT(americas_regions[1,])) #demo


#multicore, 'cause we have 20 of these to process, and each takes time
checklists_by_region <- mclapply(1:length(americas_regions@data$ECOREGION), 
              function(x) checklist(geometry = writeWKT(americas_regions[x,])),
              mc.cores=3)

names(checklists_by_region) <- as.character(americas_regions@data$ECOREGION)

#checklists_by_region <- q

for(i in 1:length(checklists_by_region)){
  checklists_by_region[[i]]$ecoregion <- americas_regions@data$ECOREGION[i]
}

checklists_by_region <- bind_rows(checklists_by_region)
save(checklists_by_region, file="../data/checklists_by_region.Rdata")

