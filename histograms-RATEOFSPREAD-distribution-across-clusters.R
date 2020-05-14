
### Histograms to understand RATEOFSPREAD distribution in the 6 clusters

#Histograms to understand RATEOFSPREAD distribution in the 6 clusters

#Values of RATEOFSPREAD for cluster 1
cluster_one_R <- subset(cust.long, clust.num == 1)
cluster_one_RATEOFSPREAD <- subset(cluster_one_R, variable == "df.RATEOFSPREAD")

#Values of RATEOFSPREAD for cluster 2
cluster_two_R <- subset(cust.long, clust.num == 2)
cluster_two_RATEOFSPREAD <- subset(cluster_two_R, variable == "df.RATEOFSPREAD")

#Values of RATEOFSPREAD for cluster 3
cluster_three_R <- subset(cust.long, clust.num == 3)
cluster_three_RATEOFSPREAD <- subset(cluster_three_R, variable == "df.RATEOFSPREAD")

#Values of RATEOFSPREAD for cluster 4
cluster_four_R <- subset(cust.long, clust.num == 4)
cluster_four_RATEOFSPREAD <- subset(cluster_four_R, variable == "df.RATEOFSPREAD")

#Values of RATEOFSPREAD for cluster 5
cluster_five_R <- subset(cust.long, clust.num == 5)
cluster_five_RATEOFSPREAD <- subset(cluster_five_R, variable == "df.RATEOFSPREAD")

#Values of RATEOFSPREAD for cluster 6 
cluster_six_R <- subset(cust.long, clust.num == 6)
cluster_six_RATEOFSPREAD <- subset(cluster_six_R, variable == "df.RATEOFSPREAD")

#Plotting RATEOFSPREAD for all 6 clusters
hist(as.numeric(cluster_one_RATEOFSPREAD$value), main = "RATEOFSPREAD Distribution for Cluster 1")
hist(as.numeric(cluster_two_RATEOFSPREAD$value), main = "RATEOFSPREAD Distribution for Cluster 2")
hist(as.numeric(cluster_three_RATEOFSPREAD$value), main = "RATEOFSPREAD Distribution for Cluster 3")
hist(as.numeric(cluster_four_RATEOFSPREAD$value), main = "RATEOFSPREAD Distribution for Cluster 4")
hist(as.numeric(cluster_five_RATEOFSPREAD$value), main = "RATEOFSPREAD Distribution for Cluster 5")
hist(as.numeric(cluster_six_RATEOFSPREAD$value), main = "RATEOFSPREAD Distribution for Cluster 6")

