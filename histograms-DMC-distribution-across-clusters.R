
### Histograms to understand DMC distribution in the 6 clusters

#Histograms to understand DMC distribution in the 6 clusters

#Values of DMC for cluster 1
cluster_one_dd <- subset(cust.long, clust.num == 1)
cluster_one_DMC <- subset(cluster_one_dd, variable == "df.DMC")

#Values of DMC for cluster 2
cluster_two_dd <- subset(cust.long, clust.num == 2)
cluster_two_DMC <- subset(cluster_two_dd, variable == "df.DMC")

#Values of DMC for cluster 3
cluster_three_dd <- subset(cust.long, clust.num == 3)
cluster_three_DMC <- subset(cluster_three_dd, variable == "df.DMC")

#Values of DMC for cluster 4
cluster_four_dd <- subset(cust.long, clust.num == 4)
cluster_four_DMC <- subset(cluster_four_dd, variable == "df.DMC")

#Values of DMC for cluster 5
cluster_five_dd <- subset(cust.long, clust.num == 5)
cluster_five_DMC <- subset(cluster_five_dd, variable == "df.DMC")

#Values of DMC for cluster 6 
cluster_six_dd <- subset(cust.long, clust.num == 6)
cluster_six_DMC <- subset(cluster_six_dd, variable == "df.DMC")

#Plotting DMC for all 6 clusters
hist(as.numeric(cluster_one_DMC$value), main = "DMC Distribution for Cluster 1")
hist(as.numeric(cluster_two_DMC$value), main = "DMC Distribution for Cluster 2")
hist(as.numeric(cluster_three_DMC$value), main = "DMC Distribution for Cluster 3")
hist(as.numeric(cluster_four_DMC$value), main = "DMC Distribution for Cluster 4")
hist(as.numeric(cluster_five_DMC$value), main = "DMC Distribution for Cluster 5")
hist(as.numeric(cluster_six_DMC$value), main = "DMC Distribution for Cluster 6")
