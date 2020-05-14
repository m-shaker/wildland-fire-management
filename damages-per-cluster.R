
### Estimated damages by each cluster

#Adding custer number to each row in the original dataset
data$clust.num <- synthetic.data$clust.num

#Getting a summary of the fire final size and estimated value of structural loss by cluster
data %>% group_by(clust.num) %>% summarise(avg_final_size = mean(as.numeric(FINAL_SIZE)),avg_loss = mean(as.numeric(STRUCT_LOSS)))

