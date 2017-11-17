
#####Let's try some plotting
coastal_plot <- function(araster, plotme = "AllTaxa", 
                         lab=paste(plotme, "Species", "Richness", sep="\n"),
                         fillPal = rev(brewer.pal(7, "Spectral")),
                         out=TRUE){

  # add to data a new column termed "id" composed of the rownames of data
  araster@data$id <- rownames(araster@data)

  # create a data.frame from our spatial object
  watershedPoints <- fortify(araster, region = "id")

  # merge the "fortified" data with the data from our spatial object
  araster_df <- merge(watershedPoints, araster@data, by = "id")
  araster_df$rich_for_plot = araster_df[[plotme]]

  ret <- ggplot(data = araster_df, aes(x=long, y=lat, group = group)) +
    geom_polygon(color=NA, mapping=aes(fill=rich_for_plot), linetype=0)  +
    scale_fill_gradientn(colors=fillPal, guide=guide_colorbar(title=lab)) +
    # scale_fill_hue(l = 40) +
    coord_equal() +
    theme_void(base_size=17) +
    theme(legend.position = "right", title = element_blank(),
          axis.text = element_blank(),
          legend.title = element_text(hjust = 1, angle = 0, size=17)) +
    xlim(c(-180,0)) +
    geom_path(data = worldmap.df %>% mutate(rich_for_plot=0) , aes(x = longitude, 
                                                           y = latitude, group = NA))
  
  if(out){
    jpeg(paste0("../Figures/", gsub("\n","", lab), ".jpg"), height=600, width=800, type = c("quartz"))
    print(ret)
    dev.off()
  }
  ret
}