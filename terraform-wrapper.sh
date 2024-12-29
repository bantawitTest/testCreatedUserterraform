#!/bin/bash
set -e

if [ "$1" == "output" ]; then
  # Filtra y captura los valores específicos de salida de Terraform
  echo "user_name: $(terraform output -raw user_name)"
  echo "access_key_id: $(terraform output -raw access_key_id)"
  echo "access_key_secret: $(terraform output -raw access_key_secret)"
else
  # Delega otros comandos a Terraform
  terraform "$@"
fi
