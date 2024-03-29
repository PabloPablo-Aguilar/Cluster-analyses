#ejercicio 4
#ejemplo de remuestreo en cluster
library(cluster)
library(gclus)
library(pvclust)
library(sf)
library(tidyverse)
#ejecutar funciones.R
mydata_3 <- scale(USArrests) 
d <-dist(mydata_3)
lista_cl <- list(
  cl_single = hclust(d, method = 'single'),
  cl_complete = hclust(d, method = 'complete'),
  cl_upgma = hclust(d, method = 'average'),
  cl_ward = hclust(d, method = 'ward.D2')
)

par(mfrow = c(2,2))
invisible(map(names(lista_cl), function(x) plot(lista_cl[[x]], main = x, hang = -1)))
par(mfrow = c(1,1))
#ver metodo idoneo
map_df(lista_cl, function(x) {
  coph_d <- cophenetic(x)
  corr <- cor(d, coph_d)
  return(corr)
})
#ver numero de cluster idoneos
anch_sil_upgma <- calcular_anchuras_siluetas(
  mc_orig = mydata_3, 
  distancias = d, 
  cluster = lista_cl$cl_upgma)
anch_sil_upgma

#reordenar para que los grupos similares queden cercanos
u_dend_reord <- reorder.hclust(lista_cl$cl_upgma, d)
plot(u_dend_reord, hang = -1)
rect.hclust(
  tree = u_dend_reord,
  k = anch_sil_upgma$n_grupos_optimo)

#evaluacion mediante remuestreo por boostrap
cl_pvclust_upgma <-
  pvclust(t(mydata_3),
          method.hclust = "average",
          method.dist = "euc",
          nboot=999,
          iseed = 91, # Resultado reproducible
          parallel = TRUE,
          weight=FALSE)

# Añadir los valores de p
plot(cl_pvclust_upgma, hang = -1)
# Añadir rectángulos a los grupos significativos
lines(cl_pvclust_upgma)
pvrect(cl_pvclust_upgma, alpha = 0.95, border = 4)

#Ejercicio permutacion 
# Cut dendrogram to obtain clusters
clusters <- cutree(lista_cl$cl_upgma, k = 6)

# Calculate silhouette for observed clustering
sil <- silhouette(clusters, d)

# Extract average silhouette width for observed clustering
sil_width_observed <- mean(sil[, "sil_width"])

# Permutation testing
num_permutations <- 999
sil_width_permuted <- replicate(num_permutations, {
  clusters_permuted <- sample(clusters)
  sil_permuted <- silhouette(clusters_permuted, d)
  mean(sil_permuted[, "sil_width"])
})
p_value <- mean(sil_width_permuted >= sil_width_observed/num_permutations)
if (p_value < 0.05) {
  print("Clustering is significant")
} else {
  print("Clustering is not significant")
}
