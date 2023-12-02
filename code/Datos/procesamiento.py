#!/usr/bin/env python3
# 1. Importing data


import pandas as pd
import requests

df = pd.read_excel("Datos/genes_preprocesados.xlsx")

df

""" # 2. Generamos la red

Como salida de la petición, se recibirán los siguientes campos de información:
- stringId_A.
- stringId_B.
- preferredName_A.
- preferredName_B.
- ncbiTaxonId.
- score. Puntuación combinada de la red.
- nscore. Puntuación de vecindad genética de la red.
- fscore. Puntuación de fusión genética.
- pscore. Puntuación del perfil filogenético de la red.
- ascore. Puntuación de coexpresión de la red.
- escore. Puntuación de experimentación.
- dscore. Puntuación de base de datos.
- tscore. Text mining score. """



base_url = "https://string-db.org/api/json/"

endpoint = "network?"

genes = df['GENE_SYMBOL'].str.cat(sep='%0d')


generatedRequest = "&".join([base_url + endpoint + "identifiers=" + genes, "species=9606", "required_score=800"])

response = requests.get(generatedRequest).json()
genes = pd.DataFrame(response)
# genes.head()

# Seleccionamos la información más relevante

resultado = genes[["preferredName_A", "preferredName_B"]]

# Guardamos los resultados

resultado.to_csv("Datos/genes_procesados.csv",index=False, header=False)
