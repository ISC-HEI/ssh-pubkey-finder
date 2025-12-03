#!/bin/bash

# Retrieve all users from the system
get_users() {
    getent passwd
}

# Check whether a user belongs to a specific group
# Args:
#   $1 - username
#   $2 - group name
# Returns:
#   0 if the user is in the group, 1 otherwise
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

# Extract all public SSH keys for a user
# Args:
#   $1 - username
#   $2 - user's home directory path
# Prints:
#   Unique keys with associated identifiers extracted from comments 
get_public_keys() {
    local username=$1
    local home_path=$2
    local PUBLIC_KEYS_PATH="$home_path/.ssh/authorized_keys"

    declare -A public_keys=()

    if [ ! -f "$PUBLIC_KEYS_PATH" ]; then
        return 0
    fi
    
    if [ ! -r "$PUBLIC_KEYS_PATH" ]; then
        echo "Access denied for $PUBLIC_KEYS_PATH."
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

main() {
    if [ "$EUID" -ne 0 ]; then
        echo -e "\\033[0;31m This script must be executed with sudo. \\033[0m"
        exit 1
    fi

    IFS=$'\n' read -r -d '' -a users < <(get_users && printf '\0')

    for user in "${users[@]}"; do
        IFS=":" read -r username _ _ _ _ home_path _ <<< "$user"

        public_keys_user=$(get_public_keys "$username" "$home_path")

        if [ -n "$public_keys_user" ]; then 
            echo "User: $username"
            echo -e "\033[32m $public_keys_user \033[0m"
        fi
    done
}

main
