###### Load libraries
library(robis)
library(dplyr)
library(purrr)

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

checklists_by_region <- map(1:2, ~checklist(geometry = writeWKT(americas_regions[.]))) 

