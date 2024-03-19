##Ejercicio 1

library(cluster)
library(factoextra)
mydata <- scale(USArrests) 
#mydata <- log(USArrests + 1) 
res.hc <- hclust(dist(mydata),  method = "complete")
fviz_dend(res.hc, cex = 0.5, k = 4, palette = "jco") 
library(pheatmap)
pheatmap(mydata, cutree_cols = 4)

?hclust

fviz_nbclust(mydata, kmeans, method = "gap_stat")
set.seed(123) # for reproducibility
km.res <- kmeans(mydata, 4, nstart = 25)
# Visualize
fviz_cluster(km.res, data = mydata, palette = "jco",
             ggtheme = theme_minimal())

#Ejercicio 2
mydata_2 <- scale(t(cluster_ejercicio_2)) #na.rm = TRUE
#cluster_ejercicio_2 <- cluster_ejercicio_2[,-1]
mydata_2 <- dist(mydata_2) 
res.hc <- hclust(mydata_2,  method = "complete")
fviz_dend(res.hc, cex = 0.5, k = 2, palette = "jco") 
library(pheatmap)
pheatmap(t(mydata_2), cutree_cols = 4)

mydata_2 <- as.matrix(mydata_2)
fviz_nbclust(mydata_2, kmeans, method = "gap_stat",k=7)
set.seed(123) # for reproducibility
km.res <- kmeans(mydata_2, 2, nstart = 25)
# Visualize
fviz_cluster(km.res, data = mydata_2, palette = "jco",
             ggtheme = theme_minimal())

#ejercicio 3
#macroinvertebrados1 <- macroinvertebrados[,-1]
#rownames(macroinvertebrados1) <- macroinvertebrados$Región
mydata_3 <- scale(macroinvertebrados1) #na.rm = TRUE
mydata_3 <- dist(mydata_3) 
res.hc <- hclust(mydata_3,  method = "ward.D2")
fviz_dend(res.hc, cex = 0.5, k = 4, palette = "jco") 
library(pheatmap)
pheatmap(t(mydata_3), cutree_cols = 4)

mydata_3 <- as.matrix(mydata_3)
fviz_nbclust(mydata_3, kmeans, method = "gap_stat")
set.seed(123) # for reproducibility
km.res <- kmeans(mydata_3, 3, nstart = 25)
# Visualize
fviz_cluster(km.res, data = mydata_3, palette = "jco",
             ggtheme = theme_minimal()) 


