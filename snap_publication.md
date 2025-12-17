# Snap Publication

This README explains how to publish the `ssh-pubkey-finder` script as a Snap.

> **ATTENTION:** If your snap requires classic confinement, you must request it on the Snapcraft forum:  
> [Classic confinement request](https://forum.snapcraft.io/c/store-requests/classic-confinement/26)

## 1. Snap Account

Go to [snapcraft.io](https://snapcraft.io) and create an account.

## 2. Build the Snap

Execute the build script:

```bash
./build-snap.sh
cd dist
```
This will create the .snap file in the dist/ directory.

## 3. Login to Snapcraft CLI
Login to your Snapcraft account:
```bash
snapcraft login
```
If it doesn't work, you may need to unlock your keyring:
```bash
seahorse
```

## 4. Register and Upload Your Snap
Register your app name:
```bash
snapcraft register ssh-pubkey-finder
```
Then upload your Snap and release it to stable:
```bash
snapcraft upload --release=stable ./ssh-pubkey-finder_0.3.0_amd64.snap
```
After upload, Snapcraft will process your snap and publish it to the store.