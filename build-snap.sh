#!/bin/bash
set -e

DIST_DIR="dist"

mkdir -p "$DIST_DIR"

# ---- Copy .yaml file ----
cp packaging/snapcraft.yaml .

# ---- Build the snap ----
echo ">> Building the snap, please wait..."
snapcraft --destructive-mode

# ---- Copy the file in the dist folder  ----
mv ssh-pubkey-finder_0.3.0_amd64.snap $DIST_DIR

# ----  Cleanup ----
rm -rf parts/ prime/ stage/ overlay/ snapcraft.yaml

echo "Your snap file is built, check it out in the dist folder"
