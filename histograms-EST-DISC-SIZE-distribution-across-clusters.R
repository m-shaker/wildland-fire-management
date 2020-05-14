
### Histograms to understand EST_DISC_SIZE distribution in the 6 clusters

#Histograms to understand EST_DISC_SIZE distribution in the 6 clusters

#Values of EST_DISC_SIZE for cluster 1
cluster_one_E <- subset(cust.long, clust.num == 1)
cluster_one_EST_DISC_SIZE <- subset(cluster_one_E, variable == "df.EST_DISC_SIZE")

#Values of EST_DISC_SIZE for cluster 2
cluster_two_E <- subset(cust.long, clust.num == 2)
cluster_two_EST_DISC_SIZE <- subset(cluster_two_E, variable == "df.EST_DISC_SIZE")

#Values of EST_DISC_SIZE for cluster 3
cluster_three_E <- subset(cust.long, clust.num == 3)
cluster_three_EST_DISC_SIZE <- subset(cluster_three_E, variable == "df.EST_DISC_SIZE")

#Values of EST_DISC_SIZE for cluster 4
cluster_four_E <- subset(cust.long, clust.num == 4)
cluster_four_EST_DISC_SIZE <- subset(cluster_four_E, variable == "df.EST_DISC_SIZE")

#Values of EST_DISC_SIZE for cluster 5
cluster_five_E <- subset(cust.long, clust.num == 5)
cluster_five_EST_DISC_SIZE <- subset(cluster_five_E, variable == "df.EST_DISC_SIZE")

#Values of EST_DISC_SIZE for cluster 6 
cluster_six_E <- subset(cust.long, clust.num == 6)
cluster_six_EST_DISC_SIZE <- subset(cluster_six_E, variable == "df.EST_DISC_SIZE")

#Plotting EST_DISC_SIZE for all 6 clusters
hist(as.numeric(cluster_one_EST_DISC_SIZE$value), main = "EST_DISC_SIZE Distribution for Cluster 1")
hist(as.numeric(cluster_two_EST_DISC_SIZE$value), main = "EST_DISC_SIZE Distribution for Cluster 2")
hist(as.numeric(cluster_three_EST_DISC_SIZE$value), main = "EST_DISC_SIZE Distribution for Cluster 3")
hist(as.numeric(cluster_four_EST_DISC_SIZE$value), main = "EST_DISC_SIZE Distribution for Cluster 4")
hist(as.numeric(cluster_five_EST_DISC_SIZE$value), main = "EST_DISC_SIZE Distribution for Cluster 5")
hist(as.numeric(cluster_six_EST_DISC_SIZE$value), main = "EST_DISC_SIZE Distribution for Cluster 6")
