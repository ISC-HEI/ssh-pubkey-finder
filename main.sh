#!/bin/bash

# Recupere les utilisateurs de la machine
get_users() {
    getent passwd
}

# Verifie si un utilisateur specifique appartient a un group specifique
# Args : username - le nom d'utilisateur de la personne a verifier
#        group - Le groupe auquel l'utilisateur doit appartenir
# Return : 1/0
have_user_group() {
    local username=$1
    local group=$2

    local user_groups
    user_groups=$(groups "$username" 2>/dev/null)

    for g in $user_groups; do
        if [ "$g" == "$group" ]; then
            return 0
        fi
    done

    return 1
}

# Recupere les cles publiques de l'utilisateur
# Args : username - Le nom d'utilisateur de la personne
#        home_path - Le chemin du home de l'utilisateur  
get_public_keys() {
    local username=$1
    local home_path=$2
    local PUBLIC_KEYS_PATH="$home_path/.ssh/authorized_keys"

    declare -A public_keys=()

    if [ ! -f "$PUBLIC_KEYS_PATH" ]; then
        return 0
    fi
    
    if [ ! -r "$PUBLIC_KEYS_PATH" ]; then
        echo "Accès impossible pour lire $PUBLIC_KEYS_PATH."
        return 1
    fi

    while IFS= read -r line; do
        [ -z "$line" ] && continue
        if [[ "$line" == \#* ]]; then
            continue
        fi

        IFS=" " read -r key_type key_data comment <<< "$line"

        key="${key_type} ${key_data}"

        user_from_comment="${comment%@*}"

        local user_label="$user_from_comment"
        if have_user_group "$user_from_comment" "sudo"; then
            user_label+=" (sudo)"
        fi

        if [[ -n "${public_keys[$key]}" ]]; then
            public_keys[$key]+=", $user_label"
        else
            public_keys[$key]="$user_label"
        fi
    done < "$PUBLIC_KEYS_PATH"

    for k in "${!public_keys[@]}"; do
        echo "$k: ${public_keys[$k]}"
    done
}

# programme principal
main() {
    if [ "$EUID" -ne 0 ]; then
        echo -e "\\033[0;31m Ce script doit être exécuté avec sudo. \\033[0m"
        exit 1
    fi

    IFS=$'\n' read -r -d '' -a users < <(get_users && printf '\0')

    for user in "${users[@]}"; do
        IFS=":" read -r username _ _ _ _ home_path _ <<< "$user"

        public_keys_user=$(get_public_keys "$username" "$home_path")

        if [ -n "$public_keys_user" ]; then 
            echo "Utilisateur : $username"
            echo -e "\033[32m $public_keys_user \033[0m"
        fi
    done
}

# ---------
main
