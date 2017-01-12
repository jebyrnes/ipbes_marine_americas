###### Load libraries
library(robis)
library(dplyr)
library(purrr)
library(parallel)
library(rgeos)
library(feather)

#Load Spalding's marine Ecoregions of the world
#install_github("jebyrnes/meowR")
library(meowR)
data(regions)

#### Subset down to the ecoregions of the Americas
americas <- c(53:58, 5:14, 37:43, 59:61, 62:77, 152, 163:188)

americas_regions <- subset(regions, regions$ECO_CODE_X %in% americas)

#plot(americas_regions)


###### Get checklist for each area
#check_data <- checklist(geometry = writeWKT(americas_regions[1,])) #demo


#multicore, 'cause we have 20 of these to process, and each takes time
checklists_by_region <- mclapply(1:2,#length(americas_regions@data$ECOREGION), 
                                 function(x) {
                                   #So we can follow progress
                                   cat(paste(x, "of", length(americas_regions@data$ECOREGION), "\n", sep=" "))
                                   #get the data from OBIS
                                   ret <- checklist(geometry = writeWKT(americas_regions[x,]))
                                   
                                   #ad the ecoregion
                                   ret$ecoregion <- as.character(americas_regions@data$ECOREGION[x])
                                   
                                   #write out a temporary file in case this job gets paused we can restart
                                   write.csv(ret, file = paste0("../data/checklists/", ret$ecoregion[1], ".csv"))
                                   ret
                                 },
                                 mc.cores=3)

####### Save the resulting data for later post-processing
checklists_by_region <- bind_rows(checklists_by_region)

save(checklists_by_region, file="../data/checklists_by_region.Rdata")
write.csv(checklists_by_region, file="../data/checklists.csv")
write_feather(checklists_by_region, path="../data/checklists.feather")

