
### Histograms to understand FFMC distribution in the 6 clusters

#Histograms to understand FFMC distribution in the 6 clusters

#Values of FFMC for cluster 1
cluster_one <- subset(cust.long, clust.num == 1)
cluster_one_FFMC <- subset(cluster_one, variable == "df.FFMC")

#Values of FFMC for cluster 2
cluster_two <- subset(cust.long, clust.num == 2)
cluster_two_FFMC <- subset(cluster_two, variable == "df.FFMC")

#Values of FFMC for cluster 3
cluster_three <- subset(cust.long, clust.num == 3)
cluster_three_FFMC <- subset(cluster_three, variable == "df.FFMC")

#Values of FFMC for cluster 4
cluster_four <- subset(cust.long, clust.num == 4)
cluster_four_FFMC <- subset(cluster_four, variable == "df.FFMC")

#Values of FFMC for cluster 5
cluster_five <- subset(cust.long, clust.num == 5)
cluster_five_FFMC <- subset(cluster_five, variable == "df.FFMC")

#Values of FFMC for cluster 6 
cluster_six <- subset(cust.long, clust.num == 6)
cluster_six_FFMC <- subset(cluster_six, variable == "df.FFMC")

#Plotting FFMC for all 6 clusters
hist(as.numeric(cluster_one_FFMC$value), main = "FFMC Distribution for Cluster 1")
hist(as.numeric(cluster_two_FFMC$value), main = "FFMC Distribution for Cluster 2")
hist(as.numeric(cluster_three_FFMC$value), main = "FFMC Distribution for Cluster 3")
hist(as.numeric(cluster_four_FFMC$value), main = "FFMC Distribution for Cluster 4")
hist(as.numeric(cluster_five_FFMC$value), main = "FFMC Distribution for Cluster 5")
hist(as.numeric(cluster_six_FFMC$value), main = "FFMC Distribution for Cluster 6")
