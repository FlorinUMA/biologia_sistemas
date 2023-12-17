#!/usr/bin/env Rscript

# Define the packages your script depends on
required_packages <- c('igraph', 'sets', 'enrichR')

# Find out which packages are not installed yet
packages_to_install <- setdiff(required_packages, rownames(installed.packages()))

# Install the missing packages
if(length(packages_to_install)) install.packages(packages_to_install, dependencies = TRUE)