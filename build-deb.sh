#!/bin/bash
set -e

PKG_NAME="ssh-pubkey-finder"
PKG_VERSION="0.3.0"

function create_structure() {
    mkdir DEBIAN
    cat > DEBIAN/control <<EOF
Package: $PKG_NAME
Version: $PKG_VERSION
Section: utils
Priority: optional
Architecture: all
Maintainer: Adrien Reynard <adrien.reynard@hevs.ch>
Description: This script lists the SSH public keys of system users.
 It can show all users or a specific user, and annotate keys.
EOF

    mkdir -p usr/local/bin
    cp ./ssh-pubkey-finder ./usr/local/bin/
    chmod +x usr/local/bin/ssh-pubkey-finder
}

function make_executable() {
    cd ..
    dpkg-deb --build "$PKG_NAME"
    mv "${PKG_NAME}.deb" "$PKG_NAME"
    cd "$PKG_NAME"
}

function remove_structure() {
    rm -rf usr/ DEBIAN/
}

function main() {
    rm -f ssh-pubkey-finder.deb
    create_structure
    make_executable
    remove_structure
    echo "SUCCESS: The executable has been created"
}

main
