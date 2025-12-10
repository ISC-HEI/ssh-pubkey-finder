# SSH Pubkey Finder

![OS](https://img.shields.io/badge/OS-linux-0078D4)
![Language](https://img.shields.io/badge/language-bash-239120)
![GitHub Release](https://img.shields.io/github/v/release/ISC-HEI/ssh-pubkey-finder)
![Release Date](https://img.shields.io/github/release-date/ISC-HEI/ssh-pubkey-finder)
![Last Commit](https://img.shields.io/github/last-commit/ISC-HEI/ssh-pubkey-finder)

**SSH Pubkey Finder** is a Bash script that allows you to retrieve all the authorized SSH public keys on a Linux system. For each user, the script can also specify the groups to which he belongs.


## Table of Contents
- [Features](#features)
- [Installation](#installation)
- [Script Execution](#script-execution)
    - [Arguments](#arguments)
    - [Example](#example)
- [Debian executable](#debian-executable)
- [Package repository](#package-repository)
    - [Adding the repository to your system](#adding-the-repository-to-your-system)
- [License](#license)


## Features
- Retrieves all users on the system.
- Lists authorized SSH public keys for each user.
- Allows specifying a user’s group.

## Installation

Clone the GitHub repository:

```bash
git clone https://github.com/ISC-HEI/ssh-pubkey-finder.git
cd ssh-pubkey-finder
```

## Script Execution
Run the script using the following command:
```bash
# Make sure the script is executable (normally it is)
chmod +x ssh-pubkeys-finder

# Execute the script
./ssh-pubkeys-finder
```

### Arguments
| **Argument** |         **Description**           |         **Params**        |
|:------------:|:---------------------------------:|:-------------------------:|
| -h           | Show help                         |             X             |
| -v           | Show the current version          |             X             |
| -u USER      | Check only for the specified user |  USER: the user to check  |

### Example
Here you can see an example of output with no argument:
```bash
admin@mypc:~/$ ./ssh-pubkey-finder
Permission denied, root may have some public keys
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICBeVf+bmAsL6O0li173PA8dw4qSWwU1v3WegXGB26IV adrien
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOgJnqfqwBihTBLfBn0+SEr0W1oWz13mUFFZ56XSYoC8 adrien
```

```bash
admin@mypc:~/$ sudo ./ssh-pubkey-finder
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICBeVf+bmAsL6O0li173PA8dw4qSWwU1v3WegXGB26IV adrien, local
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOgJnqfqwBihTBLfBn0+SEr0W1oWz13mUFFZ56XSYoC8 adrien
```
Here you can see an example with the specified user
```bash
admin@mypc:~/$ sudo ./ssh-pubkey-finder -u adrien
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICBeVf+bmAsL6O0li173PA8dw4qSWwU1v3WegXGB26IV adrien
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOgJnqfqwBihTBLfBn0+SEr0W1oWz13mUFFZ56XSYoC8 adrien

```

## Debian executable

This project includes a script to generate a Debian package (`.deb`) for easy installation:
```bash
./build-deb.sh
```

Once the `.deb` file is created, you can install it with:
```bash
sudo dpkg -i ssh-pubkey-finder.deb
```

Verify the installation:
```bash
ssh-pubkey-finder -v
# Output : 0.2.0
```
This allows you to run `ssh-pubkey-finder` from anywhere on your system like a standard command.

## Package repository
You can create a local Debian package repository using the provided script:
```bash
./build-repo.sh
``` 
> Note: This script requires a `.deb` file generated with [Debian Executable](#debian-executable)

Once the repository is created, you can add it to your system’s APT sources and install the package like any standard Debian package.

### Adding the repository to your system

1. Copy the repository to a location on your system, e.g., /home/username/ssh-pubkey-repo.
> Replace `/home/username` with your actual home path
2. Add the repository to APT sources:
```bash
echo "deb [trusted=yes] file:/home/username/ssh-pubkey-repo ./" | sudo tee /etc/apt/sources.list.d/ssh-pubkey-finder.list
```

3. Update APT and install the package:
```bash
sudo apt update
sudo apt install ssh-pubkey-finder
 ```

This setup allows you to manage updates or deploy `ssh-pubkey-finder` across multiple systems easily.

## License
The current License is Apache version 2.0, you can see it in the [LICENSE](LICENSE) file.