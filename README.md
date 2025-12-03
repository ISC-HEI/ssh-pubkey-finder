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
    - [Example](#example)
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
chmod +x ssh-pubkeys-finder.sh

# Execute the script
./ssh-pubkeys-finder.sh
```

### Example
here you can see an examle of output:
```bash
admin@mypc:~/$ ./ssh-pubkey-finder.sh
User: root
 Permission denied, this user may have some public keys 
User: adrien
 ssh-ed25519 AABAC3NzaC1lZDI1NTE9UAAAIOgJnqfqwBihTBOwVn0+SEr0W1oWz13mUFFZ56XSYoC8: local, adrien(sudo) 
User: local
 Permission denied, this user may have some public keys
```

## License
The current License is Apache version 2.0, you can see it in the [LICENSE](LICENSE) file.