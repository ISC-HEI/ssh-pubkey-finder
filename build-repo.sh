#!/bin/bash
set -e

PKG_NAME="ssh-pubkey-finder"
ARCH="amd64"
DIST="stable"
SECTION="main"

function check_debian_executable() {
    if [ ! -e "$PKG_NAME.deb" ]; then
        echo "error: EPERM, the .deb file doesn't exist."
        exit 1
    fi
}


function update_and_install_dep() {
    sudo apt update
    sudo apt install -y dpkg-dev gnupg
}

function create_structure() {
    mkdir -p repo/dists/$DIST/$SECTION/binary-$ARCH
    mkdir -p repo/pool/$SECTION

    cp "$PKG_NAME".deb repo/pool/$SECTION/
}

function create_packages() {
    cd repo

    dpkg-scanpackages "pool/$SECTION" /dev/null > dists/$DIST/$SECTION/binary-$ARCH/Packages
    gzip -kf dists/$DIST/$SECTION/binary-$ARCH/Packages

    cd ..
}

function main() {
    check_debian_executable
    
    rm -rf repo/
    update_and_install_dep
    create_structure
    create_packages
    echo "SUCCESS: The package repository has been created"
}

main
