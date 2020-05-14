
### Distribution of groups responsible for the fire across clusters

#Heatmap to see how the groups responsible for the fire are distributed across clusters

clust.num <- cutree(divisive.clust, k = 6)
synthetic.data <- cbind(converted_df, clust.num)
cust.long <- melt(data.frame(lapply(synthetic.data, as.character), stringsAsFactors=FALSE), 
                  id = c("id", "clust.num"), factorsAsStrings=T)

cust.long.q <- cust.long %>%
  group_by(clust.num, variable, value) %>%
  mutate(count = n_distinct(id)) %>%
  distinct(clust.num, variable, value, count)

heatmap.c <- ggplot(cust.long.q, aes(x =clust.num, y =factor(value, levels = c("ANG","ATO","BER","CAM","CAN","CAR","CHI","COT","CRO","FAR","FED","GUI","HIK","HUN","LTG","MIE","MIL","MIS","MNR","MUN","OIE","PGE","PIC","POE","PRO","RER","REU","RME","RSC","RTC","RWC","TRA","TRP","UNK","WIE","YOU","YTH"), ordered = T))) +geom_tile(aes(fill = count))+scale_fill_gradient2(low = "darkslategray1", mid = "yellow", high = "turquoise4")

#Calculating the percent of each factor level in the absolute count of cluster members
cust.long.p <- cust.long.q %>%
  group_by(clust.num, variable) %>%
  mutate(perc = count / sum(count)) %>%
  arrange(clust.num)

heatmap.p <- ggplot(cust.long.p, aes(x = clust.num, y = factor(value, levels = c("ANG","ATO","BER","CAM","CAN","CAR","CHI","COT","CRO","FAR","FED","GUI","HIK","HUN","LTG","MIE","MIL","MIS","MNR","MUN","OIE","PGE","PIC","POE","PRO","RER","REU","RME","RSC","RTC","RWC","TRA","TRP","UNK","WIE","YOU","YTH"), ordered = T))) + geom_tile(aes(fill = perc), alpha = 0.85)+
  labs(title = "Distribution of groups responsible for the fire across clusters", x = "Cluster number", y = NULL) +
  geom_hline(yintercept = 3.5) + 
  geom_hline(yintercept = 10.5) + 
  geom_hline(yintercept = 13.5) + 
  geom_hline(yintercept = 17.5) + 
  geom_hline(yintercept = 21.5) + 
  scale_fill_gradient2(low = "darkslategray1", mid = "yellow", high = "turquoise4")

heatmap.p
