
### Calculating dissimilarity matrix

#Calculating a dissimilarity matrix
library(cluster) 
gower.dist <- daisy(converted_df[ ,2:length(converted_df)], metric = c("gower"))


### Hierarchical clustering using the divisive clustering method

#Hierarchical clustering using the divisive clustering method
divisive.clust <- diana(as.matrix(gower.dist), 
                        diss = TRUE, keep.diss = TRUE)
plot(divisive.clust, main = "Divisive")
