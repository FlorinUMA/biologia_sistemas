#!/usr/bin/env Rscript

# Importamos librerías
library("igraph")
library("enrichR")

pdf(NULL)

# 2. Generamos los grafos

nodes <-
  read.csv("Datos/genes_procesados.csv",
           header = FALSE,
           as.is = TRUE)
nodos <- union(nodes$V1, nodes$V2)

# Crea un dataframe de nodos
df_nodos <- data.frame(Nodo = nodos)

# Crear el grafo
net <-
  simplify(
    graph_from_data_frame(d = nodes, directed = FALSE),
    remove.multiple = FALSE,
    remove.loops = TRUE
  )

# Detección de comunidades
comunidades <- cluster_louvain(net)

# Asignar colores a las comunidades
colores_comunidades <- rainbow(max(membership(comunidades)))
colores_nodos <- colores_comunidades[membership(comunidades)]
df_nodos$Color <- colores_nodos

# Guardar el grafo con colores de comunidades como imagen
png("RESULTADOS/grafo_colores_comunidades.png")
plot(net, vertex.color = colores_nodos, main = "Grafo con Colores de Comunidades")
legend(
  "topright",
  legend = unique(membership(comunidades)),
  fill = colores_comunidades,
  title = "Comunidades"
)
dev.off()

# Detectar comunidades (de nuevo) y crear el dendrograma
community <- cluster_edge_betweenness(net)
png("RESULTADOS/grafo_alternativo_comunidades.png")
plot(community, net)
dev.off()

# Comparar las comunidades obtenidas por distintos algoritmos
conjuntos_comunidades1 <- comunidades$membership
conjuntos_comunidades2 <- community$membership
posiciones_diferentes <-
  which(conjuntos_comunidades1 != conjuntos_comunidades2)
df <-
  data.frame(Nodos = conjuntos_comunidades1,
             Enlaces = conjuntos_comunidades2,
             Diferentes = "Iguales")
df$Diferentes[posiciones_diferentes] <- "Diferentes"
sink("RESULTADOS/comunidades.txt", append = FALSE)
print(df)  # Imprimir el dataframe df en comunidades.txt
sink()

# Calcular modularidad y comparar los valores
modularity_node <- max(comunidades$modularity)
modularity_enlace <- max(community$modularity)
total <- c(modularity_node, modularity_enlace)
png("RESULTADOS/comparacion_grafos.png")
barplot(
  total,
  col = "skyblue",
  main = "Gráfico de Barras",
  xlab = "Categorías",
  ylab = "Valores",
  names.arg = c("nodos", "enlace")
)
dev.off()

# Análisis de enriquecimiento
databases <- c("GO_Biological_Process_2018")

# Función para filtrar por número de genes
filtrar_palabra <- function(lista, t_tam) {
  filtrado <- lista
  umbral = 1
  num_true = 0
  while (num_true == 0) {
    filtrado <- FALSE
    for (i in 1:length(lista)) {
      palabra <- length(strsplit(lista[i], ";")[[1]])
      filtrado[[i]] = (palabra >= t_tam * umbral)
    }
    num_true = sum(filtrado)
    if (num_true == 0) {
      umbral = umbral - 0.1
    } else {
      break
    }
  }
  return(filtrado)
}

# Función para realizar análisis de enriquecimiento
enriquecimiento <- function(comunidades) {
  for (i in 1:length(comunidades)) {
    # Realizar el análisis de enriquecimiento
    enrich_result <- enrichr(gene   = comunidades[[i]],
                             databases =   databases)
    # Filtramos lo resultados por un p valor mayor a 0.05
    filtro_p <-
      enrich_result$GO_Biological_Process_2018$Adjusted.P.value < 0.05
    
    # Filtramos por un número de genes mayor a la mita de la comunidad
    filtro_Genes <-
      filtrar_palabra(enrich_result$GO_Biological_Process_2018$Genes,
                      length(comunidades[[i]])) == TRUE
    
    # Realizamos la intersección entre los valores true del filtrado por p y del filtrado por genes.
    datos_final <-
      interseccion <- intersect(which(filtro_p), which(filtro_Genes))
    
    # Concatenar los elementos del vector en una única cadena
    genes <- paste(comunidades[[i]], collapse = ",")
    df1 <-
      data.frame(genes = genes,
                 funciones = enrich_result$GO_Biological_Process_2018$Term[datos_final])
    print(df1)
  }
}

sink("RESULTADOS/enriquecimiento.txt", append = FALSE)
enriquecimiento(comunidades)  # La salida de esta función se guardará en enriquecimiento.txt
sink()

graphics.off()
