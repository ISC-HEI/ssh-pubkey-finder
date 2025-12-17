<div align="center">

# SSH Pubkey Finder

![OS](https://img.shields.io/badge/OS-linux-0078D4)
![Language](https://img.shields.io/badge/language-bash-239120)
![GitHub Release](https://img.shields.io/github/v/release/ISC-HEI/ssh-pubkey-finder)
![Release Date](https://img.shields.io/github/release-date/ISC-HEI/ssh-pubkey-finder)
![Last Commit](https://img.shields.io/github/last-commit/ISC-HEI/ssh-pubkey-finder)

**SSH Pubkey Finder** is a Bash script that allows you to retrieve all the authorized SSH public keys on a Linux system.
</div>

## Table of Contents
- [Features](#features)
- [Installation](#installation)
    - [Installing from Github](#installing-from-github)
    - [Installing via apt](#installing-via-apt-for-debianubuntu)
- [Script Execution](#script-execution)
    - [Arguments](#arguments)
    - [Example](#example)
- [License](#license)


## Features
- Retrieves all users on the system.
- Lists authorized SSH public keys for each user.
- Allows specifying a user’s group.

## Installation
### Installing from GitHub

Clone the GitHub repository:
```bash
git clone https://github.com/ISC-HEI/ssh-pubkey-finder.git
cd ssh-pubkey-finder
```

### Installing via apt (for Debian/Ubuntu)

You can add the official repository and install the package directly:
1. Add the repository to your system:
```bash
echo "deb [trusted=yes] https://apt.chezmoicamarche.ch/ssh-pubkey-finder/repo stable main" | sudo tee /etc/apt/sources.list.d/ssh-pubkey-finder.list
```
2. Update your package lists and install the package:
```bash
sudo apt update
sudo apt install ssh-pubkey-finder
```
3. Run the script:
```bash
ssh-pubkey-finder -v
# Output: 0.3.0
```
> Note: Installing via apt makes the script available system-wide, so you don’t need to be in the repository folder to run it.
## Script Execution
Run the script using the following command:

If the script is installed system-wide:
```bash
ssh-pubkey-finder
```

If running directly from the cloned repository:
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

## License
The current License is Apache version 2.0, you can see it in the [LICENSE](LICENSE) file.
