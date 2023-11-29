#!/usr/bin/env Rscript
# STRINGdb
if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("STRINGdb")

# igraph
if (!require("igraph")) {
    install.packages("igraph")
}

# enrichR
if (!require("enrichR")) {
    install.packages("enrichR")
}

# rmarkdown
if (!require("rmarkdown")) {
install.packages("rmarkdown")
}

# rmarkdown
if (!require("sets")) {
  install.packages("sets")
}

