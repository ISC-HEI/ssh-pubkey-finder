#!/bin/bash
set -e

PKG_NAME="ssh-pubkey-finder"
PKG_VERSION="0.3.0"
TMP_DIR="tmp/${PKG_NAME}-${PKG_VERSION}"
DIST_DIR="dist"
FILE_SOURCE="packaging"

rm -rf "$TMP_DIR"
mkdir -p "$TMP_DIR"
mkdir -p "$DIST_DIR"

echo ">> Creating package structure in $TMP_DIR"

mkdir -p "$TMP_DIR/DEBIAN"
mkdir -p "$TMP_DIR/usr/bin"
mkdir -p "$TMP_DIR/usr/share/doc/$PKG_NAME"
mkdir -p "$TMP_DIR/usr/share/man/man1"

# ---- Bash script ----
cp "./$PKG_NAME" "$TMP_DIR/usr/bin/"
chmod 755 "$TMP_DIR/usr/bin/$PKG_NAME"

# ---- Changelog ----
cp "$FILE_SOURCE/changelog" "$TMP_DIR/usr/share/doc/$PKG_NAME/changelog"
gzip -9 -n "$TMP_DIR/usr/share/doc/$PKG_NAME/changelog"

# ---- License & README ----
cp README.md "$TMP_DIR/usr/share/doc/$PKG_NAME/"
cp LICENSE "$TMP_DIR/usr/share/doc/$PKG_NAME/"

# ---- Copyright ----
cp "$FILE_SOURCE/copyright" "$TMP_DIR/usr/share/doc/$PKG_NAME/"

# ---- Control ----
cp "$FILE_SOURCE/control" "$TMP_DIR/DEBIAN/control"
chmod 644 "$TMP_DIR/DEBIAN/control"

# ---- Man page ----
cp "$FILE_SOURCE/ssh-pubkey-finder.1" "$TMP_DIR/usr/share/man/man1/"
gzip -9 -n "$TMP_DIR/usr/share/man/man1/ssh-pubkey-finder.1"

# ---- Cleanup git files ----
find "$TMP_DIR" -name ".git*" -exec rm -rf {} +

# ---- Fix permissions ----
find "$TMP_DIR" -type d -exec chmod 755 {} \;
find "$TMP_DIR/usr/share" -type f -exec chmod 644 {} \;
chmod 755 "$TMP_DIR/usr/bin/$PKG_NAME"
chmod 755 "$TMP_DIR/usr/share/doc/$PKG_NAME"

# ---- Build ----
DEB_OUTPUT="${DIST_DIR}/${PKG_NAME}_${PKG_VERSION}.deb"
fakeroot dpkg-deb --build "$TMP_DIR" "$DEB_OUTPUT"

rm -rf "$TMP_DIR"

echo "SUCCESS: $DEB_OUTPUT has been created"