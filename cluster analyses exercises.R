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



