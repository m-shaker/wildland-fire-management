
### Histograms to understand BUI distribution in the 6 clusters

#Histograms to understand BUI distribution in the 6 clusters

#Values of BUI for cluster 1
cluster_one_B <- subset(cust.long, clust.num == 1)
cluster_one_BUI <- subset(cluster_one_B, variable == "df.BUI")

#Values of BUI for cluster 2
cluster_two_B <- subset(cust.long, clust.num == 2)
cluster_two_BUI <- subset(cluster_two_B, variable == "df.BUI")

#Values of BUI for cluster 3
cluster_three_B <- subset(cust.long, clust.num == 3)
cluster_three_BUI <- subset(cluster_three_B, variable == "df.BUI")

#Values of BUI for cluster 4
cluster_four_B <- subset(cust.long, clust.num == 4)
cluster_four_BUI <- subset(cluster_four_B, variable == "df.BUI")

#Values of BUI for cluster 5
cluster_five_B <- subset(cust.long, clust.num == 5)
cluster_five_BUI <- subset(cluster_five_B, variable == "df.BUI")

#Values of BUI for cluster 6 
cluster_six_B <- subset(cust.long, clust.num == 6)
cluster_six_BUI <- subset(cluster_six_B, variable == "df.BUI")

#Plotting BUI for all 6 clusters
hist(as.numeric(cluster_one_BUI$value), main = "BUI Distribution for Cluster 1")
hist(as.numeric(cluster_two_BUI$value), main = "BUI Distribution for Cluster 2")
hist(as.numeric(cluster_three_BUI$value), main = "BUI Distribution for Cluster 3")
hist(as.numeric(cluster_four_BUI$value), main = "BUI Distribution for Cluster 4")
hist(as.numeric(cluster_five_BUI$value), main = "BUI Distribution for Cluster 5")
hist(as.numeric(cluster_six_BUI$value), main = "BUI Distribution for Cluster 6")

