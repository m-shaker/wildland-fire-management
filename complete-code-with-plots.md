---
title: "complete-code-with-plots"
author: "Moustafa"
date: "5/14/2020"
output: 
    html_document: 
       keep_md: true
---

### Section 1: Data importing and manipulation


```r
#Reading the data
data = read.csv('cleaned_data.csv')

#Feature selection
interesting_features = c('FFMC','DMC','DC','ISI','BUI','FWI',
                  'FUEL_TYPE','RATEOFSPREAD','EST_DISC_SIZE',
                  'GENERAL_CAUSE','GENERAL_IGN',
                  'RESP_GROUP')

#Dataframe with selected features
library(dplyr)
```

```
## 
## Attaching package: 'dplyr'
```

```
## The following objects are masked from 'package:stats':
## 
##     filter, lag
```

```
## The following objects are masked from 'package:base':
## 
##     intersect, setdiff, setequal, union
```

```r
df = select(data,interesting_features)

#Number of rows in the data
data_length = nrow(data)

#Generating an id for each entry 
id <- c(1:data_length) %>% factor()

#Adding id for original data
data$id <- id

#Making a new dataframe to convert all strings to factors
converted_df <- data.frame(id, df$FFMC, df$DMC, df$DC, df$ISI, df$BUI, df$FWI, df$FUEL_TYPE, df$RATEOFSPREAD, df$EST_DISC_SIZE, df$GENERAL_CAUSE, df$GENERAL_IGN, df$RESP_GROUP)
```

### Section 2: Calculating dissimilarity matrix


```r
#Calculating a dissimilarity matrix
library(cluster) 
gower.dist <- daisy(converted_df[ ,2:length(converted_df)], metric = c("gower"))
```

### Section 3: Hierarchical clustering using the divisive clustering method


```r
#Hierarchical clustering using the divisive clustering method
divisive.clust <- diana(as.matrix(gower.dist), 
                  diss = TRUE, keep.diss = TRUE)
plot(divisive.clust, main = "Divisive")
```

![](complete-code-with-plots_files/figure-html/unnamed-chunk-3-1.png)<!-- -->![](complete-code-with-plots_files/figure-html/unnamed-chunk-3-2.png)<!-- -->

### Section 4: Function to calculate statistics about cluters


```r
#Cluster stats to help decide on the optimal number of clusters
library(fpc)
```

```
## Warning: package 'fpc' was built under R version 3.6.3
```

```r
cstats.table <- function(dist, tree, k) {
clust.assess <- c("cluster.number","n","within.cluster.ss","average.within","average.between",
                  "wb.ratio","dunn2","avg.silwidth")
clust.size <- c("cluster.size")
stats.names <- c()
row.clust <- c()
output.stats <- matrix(ncol = k, nrow = length(clust.assess))
cluster.sizes <- matrix(ncol = k, nrow = k)
for(i in c(1:k)){
  row.clust[i] <- paste("Cluster-", i, " size")
}
for(i in c(2:k)){
  stats.names[i] <- paste("Test", i-1)
  
  for(j in seq_along(clust.assess)){
    output.stats[j, i] <- unlist(cluster.stats(d = dist, clustering = cutree(tree, k = i))[clust.assess])[j]
    
  }
  
  for(d in 1:k) {
    cluster.sizes[d, i] <- unlist(cluster.stats(d = dist, clustering = cutree(tree, k = i))[clust.size])[d]
    dim(cluster.sizes[d, i]) <- c(length(cluster.sizes[i]), 1)
    cluster.sizes[d, i]
    
  }
}
output.stats.df <- data.frame(output.stats)
cluster.sizes <- data.frame(cluster.sizes)
cluster.sizes[is.na(cluster.sizes)] <- 0
rows.all <- c(clust.assess, row.clust)
output <- rbind(output.stats.df, cluster.sizes)[ ,-1]
colnames(output) <- stats.names[2:k]
rownames(output) <- rows.all
is.num <- sapply(output, is.numeric)
output[is.num] <- lapply(output[is.num], round, 2)
output
}
```

### Section 5: Calculating clusters statistics up to 8 clusters


```r
#Getting the cluster stats up until 8 clusters 
stats.df.divisive <- cstats.table(gower.dist, divisive.clust, 8)
stats.df.divisive
```

```
##                    Test 1  Test 2  Test 3  Test 4  Test 5  Test 6  Test 7
## cluster.number       2.00    3.00    4.00    5.00    6.00    7.00    8.00
## n                 2532.00 2532.00 2532.00 2532.00 2532.00 2532.00 2532.00
## within.cluster.ss  142.67  105.47   97.04   87.51   78.64   77.61   76.07
## average.within       0.31    0.27    0.25    0.24    0.23    0.23    0.23
## average.between      0.40    0.41    0.41    0.41    0.40    0.41    0.40
## wb.ratio             0.78    0.65    0.63    0.60    0.57    0.57    0.56
## dunn2                1.20    1.19    1.15    1.18    1.17    1.03    0.93
## avg.silwidth         0.22    0.33    0.34    0.36    0.39    0.37    0.36
## Cluster- 1  size  1400.00  697.00  697.00  297.00  297.00  297.00  223.00
## Cluster- 2  size  1132.00 1132.00  967.00  967.00  967.00  967.00  967.00
## Cluster- 3  size     0.00  703.00  703.00  703.00  703.00  695.00  695.00
## Cluster- 4  size     0.00    0.00  165.00  400.00  188.00  188.00  188.00
## Cluster- 5  size     0.00    0.00    0.00  165.00  212.00  212.00  212.00
## Cluster- 6  size     0.00    0.00    0.00    0.00  165.00  165.00  165.00
## Cluster- 7  size     0.00    0.00    0.00    0.00    0.00    8.00   74.00
## Cluster- 8  size     0.00    0.00    0.00    0.00    0.00    0.00    8.00
```

### Section 6: Choosing the number of clusters using the elbow method 


```r
#Choosing the number of clusters using the elbow method
library(ggplot2)
library(purrr)
```

```
## Warning: package 'purrr' was built under R version 3.6.3
```

```r
ggplot(data = data.frame(t(cstats.table(gower.dist, divisive.clust, 15))), 
  aes(x=cluster.number, y=within.cluster.ss)) + 
  geom_point()+
  geom_line()+
  ggtitle("Divisive clustering") +
  labs(x = "Num.of clusters", y = "Within clusters sum of squares (SS)") +
  theme(plot.title = element_text(hjust = 0.5))
```

![](complete-code-with-plots_files/figure-html/unnamed-chunk-6-1.png)<!-- -->


### Section 7: Silhouette method to find the optimal number of clusters

We will also use the Silhouette method to compare how the optimal number of clusters differ from what we found using the elbow method. 

```r
#Finding the optimal number of clusters using the Silhouette method
ggplot(data = data.frame(t(cstats.table(gower.dist, divisive.clust, 15))), 
  aes(x=cluster.number, y=avg.silwidth)) + 
  geom_point()+
  geom_line()+
  ggtitle("Divisive clustering") +
  labs(x = "Num.of clusters", y = "Average silhouette width") +
  theme(plot.title = element_text(hjust = 0.5))
```

![](complete-code-with-plots_files/figure-html/unnamed-chunk-7-1.png)<!-- -->

Both methods show that 6 clusters is the optimal choice. 

### Section 8: Dendrogram for the clusters

We will now look at how observations are clustered and how they are distributed across clusters

```r
library("ggplot2")
library("reshape2")
library("purrr")
library("dplyr")

#Plotting a dendrogram
library("dendextend")
```

```
## Warning: package 'dendextend' was built under R version 3.6.2
```

```
## 
## ---------------------
## Welcome to dendextend version 1.13.3
## Type citation('dendextend') for how to cite the package.
## 
## Type browseVignettes(package = 'dendextend') for the package vignette.
## The github page is: https://github.com/talgalili/dendextend/
## 
## Suggestions and bug-reports can be submitted at: https://github.com/talgalili/dendextend/issues
## Or contact: <tal.galili@gmail.com>
## 
## 	To suppress this message use:  suppressPackageStartupMessages(library(dendextend))
## ---------------------
```

```
## 
## Attaching package: 'dendextend'
```

```
## The following object is masked from 'package:stats':
## 
##     cutree
```

```r
dendro <- as.dendrogram(divisive.clust)

dendro.col <- dendro %>% set("branches_k_color", k = 6, value =   c("darkslategray", "darkslategray4", "darkslategray3", "gold3", "darkcyan", "cyan3", "gold3")) %>% set("branches_lwd", 0.6) %>% set("labels_colors",   value = c("darkslategray")) %>% set("labels_cex", 0.5)
```

```
## Warning in get_col(col, k): Length of color vector was longer than the number of
## clusters - first k elements are used
```

```r
ggd1 <- as.ggdend(dendro.col)

ggplot(ggd1, theme = theme_minimal()) +
  labs(x = "Num. observations", y = "Height", title = "Dendrogram, k = 6")
```

![](complete-code-with-plots_files/figure-html/unnamed-chunk-8-1.png)<!-- -->

### Section 9: Radial plot for the clusters


```r
#Radial plot(Same plot as the one above but in a different shape)
ggplot(ggd1, labels = T) + 
  scale_y_reverse(expand = c(0.2, 0)) +
  coord_polar(theta="x")
```

![](complete-code-with-plots_files/figure-html/unnamed-chunk-9-1.png)<!-- -->

### Section 10: Distribution of fuel types across clusters


```r
#Heatmap to see how fuel types are distributed across clusters

clust.num <- cutree(divisive.clust, k = 6)
synthetic.data <- cbind(converted_df, clust.num)
cust.long <- melt(data.frame(lapply(synthetic.data, as.character), stringsAsFactors=FALSE), 
                  id = c("id", "clust.num"), factorsAsStrings=T)

cust.long.q <- cust.long %>%
  group_by(clust.num, variable, value) %>%
  mutate(count = n_distinct(id)) %>%
  distinct(clust.num, variable, value, count)

heatmap.c <- ggplot(cust.long.q, aes(x =clust.num, y =factor(value, levels = c("C1", "C2", "C3", "C4", "C5", "C6", "CCS", "CCV", "D1", "GRA", "HAR", "IKC", "M125", "M150", "M175", "M225", "M250",  "M275", "MIX", "NOD", "O1A100", "O1A50", "O1A75", "O1B100", "O1B50", "O1B75",  "OTH", "S1", "S2", "SHR", "SLA"), ordered = T))) +geom_tile(aes(fill = count))+scale_fill_gradient2(low = "darkslategray1", mid = "yellow", high = "turquoise4")

#Calculating the percent of each factor level in the absolute count of cluster members
cust.long.p <- cust.long.q %>%
  group_by(clust.num, variable) %>%
  mutate(perc = count / sum(count)) %>%
  arrange(clust.num)

heatmap.p <- ggplot(cust.long.p, aes(x = clust.num, y = factor(value, levels = c("C1", "C2", "C3", "C4", "C5", "C6", "CCS", "CCV", "D1", "GRA", "HAR", "IKC", "M125", "M150", "M175", "M225", "M250",  "M275", "MIX", "NOD", "O1A100", "O1A50", "O1A75", "O1B100", "O1B50", "O1B75",  "OTH", "S1", "S2", "SHR", "SLA"), ordered = T))) + geom_tile(aes(fill = perc), alpha = 0.85)+
  labs(title = "Distribution of fuel types across clusters", x = "Cluster number", y = NULL) +
  geom_hline(yintercept = 3.5) + 
  geom_hline(yintercept = 10.5) + 
  geom_hline(yintercept = 13.5) + 
  geom_hline(yintercept = 17.5) + 
  geom_hline(yintercept = 21.5) + 
  scale_fill_gradient2(low = "darkslategray1", mid = "yellow", high = "turquoise4")

heatmap.p
```

![](complete-code-with-plots_files/figure-html/unnamed-chunk-10-1.png)<!-- -->

### Section 11: Distribution of general causes across clusters


```r
#Heatmap to see how general causes are distributed across clusters

clust.num <- cutree(divisive.clust, k = 6)
synthetic.data <- cbind(converted_df, clust.num)
cust.long <- melt(data.frame(lapply(synthetic.data, as.character), stringsAsFactors=FALSE), 
                  id = c("id", "clust.num"), factorsAsStrings=T)

cust.long.q <- cust.long %>%
  group_by(clust.num, variable, value) %>%
  mutate(count = n_distinct(id)) %>%
  distinct(clust.num, variable, value, count)

heatmap.c <- ggplot(cust.long.q, aes(x =clust.num, y =factor(value, levels = c("IDF","IDO","INC","LTG","MIS","REC", "RES","RWY","UNK"), ordered = T))) +geom_tile(aes(fill = count))+scale_fill_gradient2(low = "darkslategray1", mid = "yellow", high = "turquoise4")

#Calculating the percent of each factor level in the absolute count of cluster members
cust.long.p <- cust.long.q %>%
  group_by(clust.num, variable) %>%
  mutate(perc = count / sum(count)) %>%
  arrange(clust.num)

heatmap.p <- ggplot(cust.long.p, aes(x = clust.num, y = factor(value, levels = c("IDF","IDO","INC","LTG","MIS","REC", "RES","RWY","UNK"), ordered = T))) + geom_tile(aes(fill = perc), alpha = 0.85)+
  labs(title = "Distribution of general causes across clusters", x = "Cluster number", y = NULL) +
  geom_hline(yintercept = 3.5) + 
  geom_hline(yintercept = 10.5) + 
  geom_hline(yintercept = 13.5) + 
  geom_hline(yintercept = 17.5) + 
  geom_hline(yintercept = 21.5) + 
  scale_fill_gradient2(low = "darkslategray1", mid = "yellow", high = "turquoise4")

heatmap.p
```

![](complete-code-with-plots_files/figure-html/unnamed-chunk-11-1.png)<!-- -->

### Section 12: Distribution of general sources of ignition across clusters


```r
#Heatmap to see how general sources of ignition are distributed across clusters

clust.num <- cutree(divisive.clust, k = 6)
synthetic.data <- cbind(converted_df, clust.num)
cust.long <- melt(data.frame(lapply(synthetic.data, as.character), stringsAsFactors=FALSE), 
                  id = c("id", "clust.num"), factorsAsStrings=T)

cust.long.q <- cust.long %>%
  group_by(clust.num, variable, value) %>%
  mutate(count = n_distinct(id)) %>%
  distinct(clust.num, variable, value, count)

heatmap.c <- ggplot(cust.long.q, aes(x =clust.num, y =factor(value, levels = c("ATV","BBP","BRA","BRU","CAM","DLC", "EQU","EXP","FIR","GAR","GRA","INC","LOC","LTG","MAT","MES","MFG","MIS","OJB","OME","PB","POW","RAC","RAG","RUB","SAW","SFC","SMM","SPA","SPB","STR","UNK","VEH","WEL"), ordered = T))) +geom_tile(aes(fill = count))+scale_fill_gradient2(low = "darkslategray1", mid = "yellow", high = "turquoise4")

#Calculating the percent of each factor level in the absolute count of cluster members
cust.long.p <- cust.long.q %>%
  group_by(clust.num, variable) %>%
  mutate(perc = count / sum(count)) %>%
  arrange(clust.num)

heatmap.p <- ggplot(cust.long.p, aes(x = clust.num, y = factor(value, levels = c("ATV","BBP","BRA","BRU","CAM","DLC", "EQU","EXP","FIR","GAR","GRA","INC","LOC","LTG","MAT","MES","MFG","MIS","OJB","OME","PB","POW","RAC","RAG","RUB","SAW","SFC","SMM","SPA","SPB","STR","UNK","VEH","WEL"), ordered = T))) + geom_tile(aes(fill = perc), alpha = 0.85)+
  labs(title = "Distribution of general sources of ignition across clusters", x = "Cluster number", y = NULL) +
  geom_hline(yintercept = 3.5) + 
  geom_hline(yintercept = 10.5) + 
  geom_hline(yintercept = 13.5) + 
  geom_hline(yintercept = 17.5) + 
  geom_hline(yintercept = 21.5) + 
  scale_fill_gradient2(low = "darkslategray1", mid = "yellow", high = "turquoise4")

heatmap.p
```

![](complete-code-with-plots_files/figure-html/unnamed-chunk-12-1.png)<!-- -->

### Section 13: Distribution of groups responsible for the fire across clusters


```r
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
```

![](complete-code-with-plots_files/figure-html/unnamed-chunk-13-1.png)<!-- -->

### Section 14: Histograms to understand FFMC distribution in the 6 clusters


```r
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
```

![](complete-code-with-plots_files/figure-html/unnamed-chunk-14-1.png)<!-- -->

```r
hist(as.numeric(cluster_two_FFMC$value), main = "FFMC Distribution for Cluster 2")
```

![](complete-code-with-plots_files/figure-html/unnamed-chunk-14-2.png)<!-- -->

```r
hist(as.numeric(cluster_three_FFMC$value), main = "FFMC Distribution for Cluster 3")
```

![](complete-code-with-plots_files/figure-html/unnamed-chunk-14-3.png)<!-- -->

```r
hist(as.numeric(cluster_four_FFMC$value), main = "FFMC Distribution for Cluster 4")
```

![](complete-code-with-plots_files/figure-html/unnamed-chunk-14-4.png)<!-- -->

```r
hist(as.numeric(cluster_five_FFMC$value), main = "FFMC Distribution for Cluster 5")
```

![](complete-code-with-plots_files/figure-html/unnamed-chunk-14-5.png)<!-- -->

```r
hist(as.numeric(cluster_six_FFMC$value), main = "FFMC Distribution for Cluster 6")
```

![](complete-code-with-plots_files/figure-html/unnamed-chunk-14-6.png)<!-- -->

### Section 15: Histograms to understand DMC distribution in the 6 clusters


```r
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
```

![](complete-code-with-plots_files/figure-html/unnamed-chunk-15-1.png)<!-- -->

```r
hist(as.numeric(cluster_two_DMC$value), main = "DMC Distribution for Cluster 2")
```

![](complete-code-with-plots_files/figure-html/unnamed-chunk-15-2.png)<!-- -->

```r
hist(as.numeric(cluster_three_DMC$value), main = "DMC Distribution for Cluster 3")
```

![](complete-code-with-plots_files/figure-html/unnamed-chunk-15-3.png)<!-- -->

```r
hist(as.numeric(cluster_four_DMC$value), main = "DMC Distribution for Cluster 4")
```

![](complete-code-with-plots_files/figure-html/unnamed-chunk-15-4.png)<!-- -->

```r
hist(as.numeric(cluster_five_DMC$value), main = "DMC Distribution for Cluster 5")
```

![](complete-code-with-plots_files/figure-html/unnamed-chunk-15-5.png)<!-- -->

```r
hist(as.numeric(cluster_six_DMC$value), main = "DMC Distribution for Cluster 6")
```

![](complete-code-with-plots_files/figure-html/unnamed-chunk-15-6.png)<!-- -->

### Section 16: Histograms to understand DC distribution in the 6 clusters


```r
#Histograms to understand DC distribution in the 6 clusters

#Values of DC for cluster 1
cluster_one_d <- subset(cust.long, clust.num == 1)
cluster_one_DC <- subset(cluster_one_d, variable == "df.DC")

#Values of DC for cluster 2
cluster_two_d <- subset(cust.long, clust.num == 2)
cluster_two_DC <- subset(cluster_two_d, variable == "df.DC")

#Values of DC for cluster 3
cluster_three_d <- subset(cust.long, clust.num == 3)
cluster_three_DC <- subset(cluster_three_d, variable == "df.DC")

#Values of DC for cluster 4
cluster_four_d <- subset(cust.long, clust.num == 4)
cluster_four_DC <- subset(cluster_four_d, variable == "df.DC")

#Values of DC for cluster 5
cluster_five_d <- subset(cust.long, clust.num == 5)
cluster_five_DC <- subset(cluster_five_d, variable == "df.DC")

#Values of DC for cluster 6 
cluster_six_d <- subset(cust.long, clust.num == 6)
cluster_six_DC <- subset(cluster_six_d, variable == "df.DC")

#Plotting DC for all 6 clusters
hist(as.numeric(cluster_one_DC$value), main = "DC Distribution for Cluster 1")
```

![](complete-code-with-plots_files/figure-html/unnamed-chunk-16-1.png)<!-- -->

```r
hist(as.numeric(cluster_two_DC$value), main = "DC Distribution for Cluster 2")
```

![](complete-code-with-plots_files/figure-html/unnamed-chunk-16-2.png)<!-- -->

```r
hist(as.numeric(cluster_three_DC$value), main = "DC Distribution for Cluster 3")
```

![](complete-code-with-plots_files/figure-html/unnamed-chunk-16-3.png)<!-- -->

```r
hist(as.numeric(cluster_four_DC$value), main = "DC Distribution for Cluster 4")
```

![](complete-code-with-plots_files/figure-html/unnamed-chunk-16-4.png)<!-- -->

```r
hist(as.numeric(cluster_five_DC$value), main = "DC Distribution for Cluster 5")
```

![](complete-code-with-plots_files/figure-html/unnamed-chunk-16-5.png)<!-- -->

```r
hist(as.numeric(cluster_six_DC$value), main = "DC Distribution for Cluster 6")
```

![](complete-code-with-plots_files/figure-html/unnamed-chunk-16-6.png)<!-- -->

### Section 17: Histograms to understand ISI distribution in the 6 clusters


```r
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
```

![](complete-code-with-plots_files/figure-html/unnamed-chunk-17-1.png)<!-- -->

```r
hist(as.numeric(cluster_two_ISI$value), main = "ISI Distribution for Cluster 2")
```

![](complete-code-with-plots_files/figure-html/unnamed-chunk-17-2.png)<!-- -->

```r
hist(as.numeric(cluster_three_ISI$value), main = "ISI Distribution for Cluster 3")
```

![](complete-code-with-plots_files/figure-html/unnamed-chunk-17-3.png)<!-- -->

```r
hist(as.numeric(cluster_four_ISI$value), main = "ISI Distribution for Cluster 4")
```

![](complete-code-with-plots_files/figure-html/unnamed-chunk-17-4.png)<!-- -->

```r
hist(as.numeric(cluster_five_ISI$value), main = "ISI Distribution for Cluster 5")
```

![](complete-code-with-plots_files/figure-html/unnamed-chunk-17-5.png)<!-- -->

```r
hist(as.numeric(cluster_six_ISI$value), main = "ISI Distribution for Cluster 6")
```

![](complete-code-with-plots_files/figure-html/unnamed-chunk-17-6.png)<!-- -->

### Section 18: Histograms to understand BUI distribution in the 6 clusters


```r
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
```

![](complete-code-with-plots_files/figure-html/unnamed-chunk-18-1.png)<!-- -->

```r
hist(as.numeric(cluster_two_BUI$value), main = "BUI Distribution for Cluster 2")
```

![](complete-code-with-plots_files/figure-html/unnamed-chunk-18-2.png)<!-- -->

```r
hist(as.numeric(cluster_three_BUI$value), main = "BUI Distribution for Cluster 3")
```

![](complete-code-with-plots_files/figure-html/unnamed-chunk-18-3.png)<!-- -->

```r
hist(as.numeric(cluster_four_BUI$value), main = "BUI Distribution for Cluster 4")
```

![](complete-code-with-plots_files/figure-html/unnamed-chunk-18-4.png)<!-- -->

```r
hist(as.numeric(cluster_five_BUI$value), main = "BUI Distribution for Cluster 5")
```

![](complete-code-with-plots_files/figure-html/unnamed-chunk-18-5.png)<!-- -->

```r
hist(as.numeric(cluster_six_BUI$value), main = "BUI Distribution for Cluster 6")
```

![](complete-code-with-plots_files/figure-html/unnamed-chunk-18-6.png)<!-- -->

### Section 19: Histograms to understand FWI distribution in the 6 clusters


```r
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
```

![](complete-code-with-plots_files/figure-html/unnamed-chunk-19-1.png)<!-- -->

```r
hist(as.numeric(cluster_two_FWI$value), main = "FWI Distribution for Cluster 2")
```

![](complete-code-with-plots_files/figure-html/unnamed-chunk-19-2.png)<!-- -->

```r
hist(as.numeric(cluster_three_FWI$value), main = "FWI Distribution for Cluster 3")
```

![](complete-code-with-plots_files/figure-html/unnamed-chunk-19-3.png)<!-- -->

```r
hist(as.numeric(cluster_four_FWI$value), main = "FWI Distribution for Cluster 4")
```

![](complete-code-with-plots_files/figure-html/unnamed-chunk-19-4.png)<!-- -->

```r
hist(as.numeric(cluster_five_FWI$value), main = "FWI Distribution for Cluster 5")
```

![](complete-code-with-plots_files/figure-html/unnamed-chunk-19-5.png)<!-- -->

```r
hist(as.numeric(cluster_six_FWI$value), main = "FWI Distribution for Cluster 6")
```

![](complete-code-with-plots_files/figure-html/unnamed-chunk-19-6.png)<!-- -->

### Section 20: Histograms to understand RATEOFSPREAD distribution in the 6 clusters


```r
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
```

![](complete-code-with-plots_files/figure-html/unnamed-chunk-20-1.png)<!-- -->

```r
hist(as.numeric(cluster_two_RATEOFSPREAD$value), main = "RATEOFSPREAD Distribution for Cluster 2")
```

![](complete-code-with-plots_files/figure-html/unnamed-chunk-20-2.png)<!-- -->

```r
hist(as.numeric(cluster_three_RATEOFSPREAD$value), main = "RATEOFSPREAD Distribution for Cluster 3")
```

![](complete-code-with-plots_files/figure-html/unnamed-chunk-20-3.png)<!-- -->

```r
hist(as.numeric(cluster_four_RATEOFSPREAD$value), main = "RATEOFSPREAD Distribution for Cluster 4")
```

![](complete-code-with-plots_files/figure-html/unnamed-chunk-20-4.png)<!-- -->

```r
hist(as.numeric(cluster_five_RATEOFSPREAD$value), main = "RATEOFSPREAD Distribution for Cluster 5")
```

![](complete-code-with-plots_files/figure-html/unnamed-chunk-20-5.png)<!-- -->

```r
hist(as.numeric(cluster_six_RATEOFSPREAD$value), main = "RATEOFSPREAD Distribution for Cluster 6")
```

![](complete-code-with-plots_files/figure-html/unnamed-chunk-20-6.png)<!-- -->

### Section 21: Histograms to understand EST_DISC_SIZE distribution in the 6 clusters


```r
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
```

![](complete-code-with-plots_files/figure-html/unnamed-chunk-21-1.png)<!-- -->

```r
hist(as.numeric(cluster_two_EST_DISC_SIZE$value), main = "EST_DISC_SIZE Distribution for Cluster 2")
```

![](complete-code-with-plots_files/figure-html/unnamed-chunk-21-2.png)<!-- -->

```r
hist(as.numeric(cluster_three_EST_DISC_SIZE$value), main = "EST_DISC_SIZE Distribution for Cluster 3")
```

![](complete-code-with-plots_files/figure-html/unnamed-chunk-21-3.png)<!-- -->

```r
hist(as.numeric(cluster_four_EST_DISC_SIZE$value), main = "EST_DISC_SIZE Distribution for Cluster 4")
```

![](complete-code-with-plots_files/figure-html/unnamed-chunk-21-4.png)<!-- -->

```r
hist(as.numeric(cluster_five_EST_DISC_SIZE$value), main = "EST_DISC_SIZE Distribution for Cluster 5")
```

![](complete-code-with-plots_files/figure-html/unnamed-chunk-21-5.png)<!-- -->

```r
hist(as.numeric(cluster_six_EST_DISC_SIZE$value), main = "EST_DISC_SIZE Distribution for Cluster 6")
```

![](complete-code-with-plots_files/figure-html/unnamed-chunk-21-6.png)<!-- -->

### Section 22: Estimated damages by each cluster


```r
#Adding custer number to each row in the original dataset
data$clust.num <- synthetic.data$clust.num

#Getting a summary of the fire final size and estimated value of structural loss by cluster
data %>% group_by(clust.num) %>% summarise(avg_final_size = mean(as.numeric(FINAL_SIZE)),avg_loss = mean(as.numeric(STRUCT_LOSS)))
```

```
## # A tibble: 6 x 3
##   clust.num avg_final_size avg_loss
##       <int>          <dbl>    <dbl>
## 1         1          1.15    1913. 
## 2         2          1.01      76.0
## 3         3          0.886     38.7
## 4         4          1.22     426. 
## 5         5         16.4     1800. 
## 6         6          7.91     991.
```

### Section 23: Conclusion/Analysis

Cluster 5 contains fires with the hightest average final size and also the hightest estimated value of structural loss. In other words, this cluster contains the most dangerous fires. Grass burn is the most frequent fuel type in this cluster. Furthermore, grass burn is one of the top 3 ignition sources for fires in this cluster. The most frequent general cause for fires in this cluster is classified as miscellaneous. Additionally, the values of fine fuel moisture code, initial spread index, fire rate of spread, and estimated size at discovery are pretty similar across all the 6 clusters. Therefore, none of those features were the driving factor that led to the fires in this cluster to be the most dangerous or destructive. Furthermore, the duff moisture code in this cluster was mostly concerntrated under 20 and the draught code under 100. The buildup index for fires in this cluster were concentrated under 20, which is on average lower than the other groups. Also, the values for the fire weather index for fires in this cluster are concerntrated under 10, which is also on average lower than all the other clusters. 

Cluster 1 comes second in the estimated value of structural loss. However, the average final size of fires in this cluster is pretty small compare to cluster 5 adn cluster 6. Grass and hardwood brush are the top fuel types represented in this category. The top ignition sources in this cluster are brush burn and grass burn. Furthermore, the most frequent general cause in this cluster is residential. This explains which we have a high value for the estimated value of structural loss with fairly small average final size. Furthermore, the duff moisture code in this cluster was mostly concerntrated under 20. Most of the draught codes are under 100 with a fair amount slightly over 100. The buildup index for fires in this cluster were concentrated between 20-30, which is a bit larger than cluster 5. Finally, the values for the fire weather index for fires in this cluster are concerntrated under 10, which is also on average lower than all the other clusters. 

Cluster 6 comes second in the average final fires size. It also has a fairly high value for the estimated value of structural loss which is approximatly 991. This is the third highest values in the 6 clusters. C5 and MIX are the most frequent fuel type in this cluster. We note that the difference in frequency between those two types and the others typs in this cluster is not very large. The most frequent general cause and ignition source for this cluster is unknown. Furthermore, the duff moisture code in this cluster was mostly concerntrated between 20-60, whic is higher than what we had in cluster 1 and 5. The draught codes in this cluster were spread fairly equally between 0 and 500. The buildup index for fires in this cluster were concentrated between 20-55 and the values for the fire weather index are concerntrated between 10-15. Again, those values are higher than what we have in cluster 1 and 5. 

Cluster 4 has the fourth highest estimated value of structural loss in all the clusters. However, it's average final size is fairly small especially if we compare it to cluster 5 and 6. Grass is the most frequent fuel type in this cluster. However, we note that the difference in frequency between grass fuel type and the others types in this cluster is not very large. The most frequent general cause in this cluster is railway employee, and the top two ignition sources are shoe brakes and grass burn. We can see that fires in this cluster are mainly the ones caused by trains' brakes operation failure near forests. Furthermore, the duff moisture code in this cluster was mostly concerntrated between 10-30, which fits in the middle of the duff moisture code for the other clusters. The draught codes in this cluster are mostly under 100, but there are a fair amount of codes over 100. The buildup index for fires in this cluster were concentrated between 10-30 and the values for the fire weather index are concerntrated under 10. 

Clusters 2 and 3 are fairly close in average final size and estimated value of structural loss. However, cluster 2 is a bit higher in both the final size and the estimated value of structural loss. The most frequent fuel type for the two clusters is C5. Even though the most frequent fuel type for both clusters is the same, the most frequent general cause and ignition source are different. The most most frequent general cause for cluster 2 is recreation and for cluster 3 it's lightning. Furthermore, the most frequent ignition source for cluster 2 is camp fire and for cluster 3 it's lightening. The distribution of the duff moisture codes, draught codes, buildup index, and fire weather index for both cluster 2 and 3 are fairly similar. The duff moisture codes are concentrated between 20 and 40, which is on average the highest values of all 6 clusters. Furthermore, the draught codes in the clusters are concentrated between 200 and 400. This is much larger on average than any of the other 6 clusters. The buildup index is concentrated between 20 and 80, while the fire weather index is concentrated between 0 and 20.  

Overall, it apears that the most significant factors that determine average final size and estimated value of structural loss are the general cause and ignition source. It also appears that the clusters that had the worest fires genrally had lower duff moisture codes, draught codes, buildup index, and fire weather index. 
