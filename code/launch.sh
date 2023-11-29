#!/usr/bin/env bash

# Ruta al script de R

ruta_origen="Datos"

echo

echo Se procesan los datos:


$ruta_origen/procesamiento.py

exit_status=$?

if [ $exit_status -ne 0 ]; then
  echo "Error al preprocesar los datos de HPO. Error code: ${exit_status}"
  exit
else
  echo "Datos procesados con exito!"
fi


echo
echo -------------------------------------------------------------------------------------------
echo
echo Eventualmente se generan los grafos de las comunidades y ficheros de texto con la información de las mismas:

# Crear la carpeta "RESULTADOS" si no existe
mkdir -p RESULTADOS


# Ejecutar el archivo .Rmd
$ruta_origen/MisGrafosFinal.R

exit_status=$?

if [ $exit_status -ne 0 ]; then
  echo "Error al ejecutar la generacion de grafos. Error code: ${exit_status}"
  exit
else
  echo "Resultados generados con exito!"
fi

echo "Script ejecutado correctamente"
