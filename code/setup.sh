#!/usr/bin/env bash

ruta_origen="Datos"

echo

echo Se instalan todas las dependencias...
$ruta_origen/packages.R
pip install -r "$ruta_origen/requirementsPython.txt"

exit_status=$?

if [ $exit_status -ne 0 ]; then
  echo "Error al instalar dependencias. Error code: ${exit_status}"
  exit
else
  echo "Dependencias instaladas con exito!"
fi

echo 
echo ------------------------------------------------------------------------------------------
echo 
