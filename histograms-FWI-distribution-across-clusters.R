
### Histograms to understand FWI distribution in the 6 clusters

#Histograms to understand FWI distribution in the 6 clusters

#Values of FWI for cluster 1
cluster_one_F <- subset(cust.long, clust.num == 1)
cluster_one_FWI <- subset(cluster_one_F, variable == "df.FWI")

#Values of FWI for cluster 2
cluster_two_F <- subset(cust.long, clust.num == 2)
cluster_two_FWI <- subset(cluster_two_F, variable == "df.FWI")

#Values of FWI for cluster 3
cluster_three_F <- subset(cust.long, clust.num == 3)
cluster_three_FWI <- subset(cluster_three_F, variable == "df.FWI")

#Values of FWI for cluster 4
cluster_four_F <- subset(cust.long, clust.num == 4)
cluster_four_FWI <- subset(cluster_four_F, variable == "df.FWI")

#Values of FWI for cluster 5
cluster_five_F <- subset(cust.long, clust.num == 5)
cluster_five_FWI <- subset(cluster_five_F, variable == "df.FWI")

#Values of FWI for cluster 6 
cluster_six_F <- subset(cust.long, clust.num == 6)
cluster_six_FWI <- subset(cluster_six_F, variable == "df.FWI")

#Plotting FWI for all 6 clusters
hist(as.numeric(cluster_one_FWI$value), main = "FWI Distribution for Cluster 1")
hist(as.numeric(cluster_two_FWI$value), main = "FWI Distribution for Cluster 2")
hist(as.numeric(cluster_three_FWI$value), main = "FWI Distribution for Cluster 3")
hist(as.numeric(cluster_four_FWI$value), main = "FWI Distribution for Cluster 4")
hist(as.numeric(cluster_five_FWI$value), main = "FWI Distribution for Cluster 5")
hist(as.numeric(cluster_six_FWI$value), main = "FWI Distribution for Cluster 6")

