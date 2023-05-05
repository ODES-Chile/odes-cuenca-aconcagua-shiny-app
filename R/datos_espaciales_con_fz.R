# install packages
#install.packages("tmap")

# library
library(sf)
library(tmap)
library(tidyverse)

# Leer datos bd_clusterizado.csv
bd_cluster <- read.csv("results/bd_clusterizado.csv", sep = ",", header = TRUE) %>% 
  rename(cod_comuna = cut_com)


# leer shape de comunas
comunas <- st_read("Comunas/comunas.shp")

# filtrar de comunas solo las que estan en la region de valparaiso
comunas_valpo <- comunas[comunas$Region == "Región de Valparaíso",]

# Join comunas_valpo y datos bd_cluster by cod_comunas
datos_combinados <- merge(comunas_valpo, bd_cluster, by = "cod_comuna")

# gráfico indice de vulnerabilidad por agricultor
tmap_mode('view')
bd_cluster %>% 
  select(location_longitude, location_latitude, ives, typo) %>% 
  st_as_sf(coords = c('location_longitude', 'location_latitude'), crs = 4326) %>% 
  tm_shape() +
  tm_dots(col = 'ives')
  
# gráfico indice de vulnerabilidad por comuna
tm_shape(datos_combinados) +
tm_fill(col = "ives", style = "order", title = "Vulnerability index") +
tm_borders() 
  

# gráfico indice de vulnerabilifdad detalles
datos_combinados %>% 
  mutate(comuna =  gsub("c_", "", comuna)) %>% 
  tm_shape() +
  tm_fill(col = "ives", style = "order", title = "Vulnerability index") +
  tm_borders() +
  tm_text(text = "comuna")

