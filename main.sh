#!/bin/bash

# A MODIFIER SELON LES MACHINES A ACCEDER
declare -A devices=(
    ["adrien@localhost"]="MOT DE PASSE A METTRE"
    ["local@localhost"]="toto1234"
)

# Affiche les cles publiques SSH autorisees listees dans $PUBLICS_KEYS_PATH
show_public_keys() {
  local username_host=$1
  local PUBLICS_KEYS_PATH="$HOME/.ssh/authorized_keys"

  echo -e "\n--- Cles Publiques autorisees pour $username_host ---"

    if [ ! -f "$PUBLICS_KEYS_PATH" ]; then
    echo -e "\033[0;33mAucun fichier authorized_keys trouve pour $username_host\033[0m"
    return
  fi

  while IFS= read -r cle; do
    if [ -n "$cle" ]; then
      echo -e "\n\033[1;32m $cle \033[0m" # Affiche en vert
    fi
  done < "$PUBLICS_KEYS_PATH"

  echo -e "\n-----------------------------------"
}

# Fonction pour se connecter à un appareil distant via SSH et executer show_public_keys
ssh_devices() {
  local username_host=$1
  local password=$2

  # Separation du nom d'utilisateur et de l'hôte
  IFS="@" read -r username remote_host <<< "$username_host"
  {
    sshpass -p "$password" ssh -o StrictHostKeyChecking=no "$username@$remote_host" "$(declare -f show_public_keys); show_public_keys $username_host"
  } || {
    echo -e "\033[31mErreur lors de la connexion a ${username_host}\033[0m"
  }
}

# Fonction principale
main() {
  for device in "${!devices[@]}"; do
      password="${devices[$device]}"
      ssh_devices "$device" "$password"
  done
}

main
