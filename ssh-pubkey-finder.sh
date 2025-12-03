#!/bin/bash

VERSION=0.1.0

user_to_check=""
group_to_show=""

process_args() {
    OPTSTRING="hu:g:v"

    while getopts ${OPTSTRING} opt; do
        case ${opt} in
            h)
                displayHelp
                exit 0
                ;;
            u)
                user_to_check="${OPTARG}"
                ;;
            g)
                group_to_show="${OPTARG}"
                ;;
            v)
                echo "${VERSION}"
                exit 0
                ;;
        esac
    done
}

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
#   $3 - group to check if the user is a member
# Prints:
#   Unique keys with associated identifiers extracted from comments 
get_public_keys() {
    local username=$1
    local home_path=$2
    local group=$3
    local PUBLIC_KEYS_PATH="$home_path/.ssh/authorized_keys"

    declare -A public_keys=()

    if ! ls "$PUBLIC_KEYS_PATH" >/dev/null 2>&1; then
        err=$(ls "$PUBLIC_KEYS_PATH" 2>&1 >/dev/null)

        if [[ "$err" == *"Permission denied"* ]]; then
            echo "Permission denied, this user may have some public keys"
            return
        else
            return
        fi
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
        if have_user_group "$user_from_comment" "${group}"; then
            user_label+=" (${group})"
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

displayHelp() {
    echo 'Usage: ./script.sh [options]

    Options:
      -h            Display this help message
      -u USER       Check only the specified user (e.g., -u local)
      -o FILE       Output results to the specified file
      -g GROUP      Note if the user is in this group
      -v            Display script version
    
    Description:
      This script lists the SSH public keys of system users.
      It can show all users or a specific user, and annotate keys.'

}

main() {
    process_args "$@"

    if [ -n "$user_to_check" ]; then
        users=()
        user_entry=$(getent passwd "$user_to_check")
        if [ -n "$user_entry" ]; then
            users+=("$user_entry")
        else
            echo "User $user_to_check not found."
            exit 1
        fi
    else
        IFS=$'\n' read -r -d '' -a users < <(get_users && printf '\0')
    fi

    for user in "${users[@]}"; do
        IFS=":" read -r username _ _ _ _ home_path _ <<< "$user"

        public_keys_user=$(get_public_keys "$username" "$home_path" "$group_to_show")

        if [ -n "$public_keys_user" ]; then 
            echo "User: $username"
            echo -e "\033[32m $public_keys_user \033[0m"
        fi
    done
}

main "$@"