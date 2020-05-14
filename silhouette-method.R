
### Silhouette method to find the optimal number of clusters

#We will also use the Silhouette method to compare how the optimal number of clusters
#differ from what we found using the elbow method. 


#Finding the optimal number of clusters using the Silhouette method
ggplot(data = data.frame(t(cstats.table(gower.dist, divisive.clust, 15))), 
       aes(x=cluster.number, y=avg.silwidth)) + 
  geom_point()+
  geom_line()+
  ggtitle("Divisive clustering") +
  labs(x = "Num.of clusters", y = "Average silhouette width") +
  theme(plot.title = element_text(hjust = 0.5))


#Both methods show that 6 clusters is the optimal choice. 