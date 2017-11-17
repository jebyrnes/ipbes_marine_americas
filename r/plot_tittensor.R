###### Load libraries
library(dplyr)
library(rgdal)
library(meowR)
library(rgeos)
library(raster)
source("./coastal_plot.R")

ogrListLayers("../global_patterns_and_predictors_of_marine_biodiversity_across_taxa")
ogrInfo("../global_patterns_and_predictors_of_marine_biodiversity_across_taxa", layer="Global_patterns_predictors_marine_biodiversity_across_taxa")

#### Get regions
data(regions)

#### Subset down to the ecoregions of the Americas
americas <- c(53:58, 5:14, 37:43, 59:61, 62:77, 152, 163:188)

americas_regions <- subset(regions, regions$ECO_CODE_X %in% americas)

##### Load taxa
all_taxa <- readOGR("../global_patterns_and_predictors_of_marine_biodiversity_across_taxa", layer="Global_patterns_predictors_marine_biodiversity_across_taxa")

ind_taxa <- readOGR("../global_patterns_and_predictors_of_marine_biodiversity_across_taxa", layer="Global_patterns_predictors_marine_biodiversity_individual_taxa")


###### Merge data and regions
all_taxa_coastal <- all_taxa + americas_regions
all_taxa_coastal <- subset(all_taxa_coastal, !is.na(all_taxa_coastal$ECO_CODE))

ind_taxa_coastal <- ind_taxa + americas_regions
ind_taxa_coastal <- subset(ind_taxa_coastal, !is.na(ind_taxa_coastal$ECO_CODE))

plot(all_taxa_coastal)

#####Let's try some plotting

coastal_plot(all_taxa_coastal, lab="Species\nRichness")
coastal_plot(all_taxa_coastal, plotme = "AllNorm")
coastal_plot(all_taxa_coastal, plotme = "CoastNorm")
coastal_plot(ind_taxa_coastal, plotme = "Coral")
coastal_plot(ind_taxa_coastal, plotme = "Cetacean")
coastal_plot(ind_taxa_coastal, plotme = "Pinniped")
coastal_plot(ind_taxa_coastal, plotme = "Mangrove")
coastal_plot(ind_taxa_coastal, plotme = "Seagrass")
coastal_plot(ind_taxa_coastal, plotme = "Squid")
coastal_plot(ind_taxa_coastal, plotme = "ForamCK")
coastal_plot(ind_taxa_coastal, plotme = "CoasFishCK", lab="Fish\nSpecies\nRichness")
coastal_plot(ind_taxa_coastal, plotme = "NonOcShark")








######OLD
# add to data a new column termed "id" composed of the rownames of data
all_taxa_coastal@data$id <- rownames(all_taxa_coastal@data)

# create a data.frame from our spatial object
watershedPoints <- fortify(all_taxa_coastal, region = "id")

# merge the "fortified" data with the data from our spatial object
all_taxa_coastal_df <- merge(watershedPoints, all_taxa_coastal@data, by = "id")



ggplot(data = all_taxa_coastal_df, aes(x=long, y=lat, group = group)) +
  geom_polygon(color=NA, mapping=aes(fill=AllTaxa, color=AllTaxa))  +
#  scale_fill_gradient(low="blue", high="red") +
 # scale_fill_hue(l = 40) +
  scale_fill_gradientn(colors=rev(brewer.pal(7, "Spectral")))+
  coord_equal() +
  theme_void() +
  theme(legend.position = "right", title = element_blank(),
        axis.text = element_blank(),
        legend.title = element_text(hjust = 1, angle = 0)) +
    xlim(c(-180,0)) +
    geom_path(data = worldmap.df %>% mutate(AllTaxa=0) , aes(x = longitude, 
                                    y = latitude, group = NA))
