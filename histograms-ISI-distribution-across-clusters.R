
### Histograms to understand ISI distribution in the 6 clusters

#Histograms to understand ISI distribution in the 6 clusters

#Values of ISI for cluster 1
cluster_one_I <- subset(cust.long, clust.num == 1)
cluster_one_ISI <- subset(cluster_one_I, variable == "df.ISI")

#Values of ISI for cluster 2
cluster_two_I <- subset(cust.long, clust.num == 2)
cluster_two_ISI <- subset(cluster_two_I, variable == "df.ISI")

#Values of ISI for cluster 3
cluster_three_I <- subset(cust.long, clust.num == 3)
cluster_three_ISI <- subset(cluster_three_I, variable == "df.ISI")

#Values of ISI for cluster 4
cluster_four_I <- subset(cust.long, clust.num == 4)
cluster_four_ISI <- subset(cluster_four_I, variable == "df.ISI")

#Values of ISI for cluster 5
cluster_five_I <- subset(cust.long, clust.num == 5)
cluster_five_ISI <- subset(cluster_five_I, variable == "df.ISI")

#Values of ISI for cluster 6 
cluster_six_I <- subset(cust.long, clust.num == 6)
cluster_six_ISI <- subset(cluster_six_I, variable == "df.ISI")

#Plotting ISI for all 6 clusters
hist(as.numeric(cluster_one_ISI$value), main = "ISI Distribution for Cluster 1")
hist(as.numeric(cluster_two_ISI$value), main = "ISI Distribution for Cluster 2")
hist(as.numeric(cluster_three_ISI$value), main = "ISI Distribution for Cluster 3")
hist(as.numeric(cluster_four_ISI$value), main = "ISI Distribution for Cluster 4")
hist(as.numeric(cluster_five_ISI$value), main = "ISI Distribution for Cluster 5")
hist(as.numeric(cluster_six_ISI$value), main = "ISI Distribution for Cluster 6")

