
### Dendrogram for the clusters

#We will now look at how observations are clustered and how they are distributed 
#across clusters

library("ggplot2")
library("reshape2")
library("purrr")
library("dplyr")

#Plotting a dendrogram
library("dendextend")
dendro <- as.dendrogram(divisive.clust)

dendro.col <- dendro %>% set("branches_k_color", k = 6, value =   c("darkslategray", "darkslategray4", "darkslategray3", "gold3", "darkcyan", "cyan3", "gold3")) %>% set("branches_lwd", 0.6) %>% set("labels_colors",   value = c("darkslategray")) %>% set("labels_cex", 0.5)

ggd1 <- as.ggdend(dendro.col)

ggplot(ggd1, theme = theme_minimal()) +
  labs(x = "Num. observations", y = "Height", title = "Dendrogram, k = 6")


### Radial plot for the clusters

#Radial plot(Same plot as the one above but in a different shape)
ggplot(ggd1, labels = T) + 
  scale_y_reverse(expand = c(0.2, 0)) +
  coord_polar(theta="x")
