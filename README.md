# custom-bash-script

**Tested with:**

- GNU bash, version 5.0.17, macOS 10.15.5
- GNU bash, version 5.0.17(1)-release (x86_64-pc-linux-gnu)

This repo contains a series of bash shell functions and aliases to speed up and simplify command execution. I have tested these on **MacOS** as well as **WSL** (Windows Subsystem for Linux). Some terminal commands may vary between OSs and could work for other shells but I have not tried them out.

## Installation

There are various ways to "install" these into your bash shell environment:

- Copy the contents that you want from this repo's `.bash_profile` file and paste them in your existing shell startup script (usually `.bash_profile`).
- Copy the `.bash_profile` file into your machine, rename it, and source it from your shell startup script using `source /path/to/file` *(This is to avoid potentially overwriting your existing `.bash_profile` file)*.
- If you have no startup script file or if it's empty, copy the `.bash_profile` file to your machine and use it as your shell startup script.

In addition, I've created an install script to automate the installation of commonly used tools and CLIs.

For more manual/specific installations, check these:

- [aws-okta](https://github.com/segmentio/aws-okta#installing)
- [Terraform](https://www.terraform.io/downloads.html)
- [Pulimi](https://www.pulumi.com/docs/get-started/install/#installing-pulumi)
- [CircleCI](https://circleci.com/docs/2.0/local-cli/#installation)
- [caniuse-cmd](https://github.com/sgentle/caniuse-cmd#caniuse-cmd)

### BASTION CONNECT

These commands are used to connect to a server or service through a Bastion in AWS using the ec2-instance-connect and aws-okta commands. If your case does not require Okta, you can remove the `aws-okta exec $1 --` part. The `bastion_dev` and `bastion_prod` files are used to select between 2 AWS accounts and can be modified to fit your specific setup (use the `bastion_template` file and rename it as you wish).

#### Setup

1. Fill in the `bastion_template` file with your account info.
1. Add `source /path/to/bastion_template` to your `.profile` file to have that bastion setup as the default.
1. Modify scripts to point to your environment name.

#### Commands - Bastion

The general command flow work by first pushing your public key to the bastion, then using the connect commands within a 60-second time frame to establish a connection. You can also print out the current environment and switch between environments (mine are setup as development and production).

Command | Definition
--- | ---
bee | Print our current bastion environment
bce | Chance bastion environment (currently hardcoded between development and production)
bkp | Push public key to the bastion
ssh-a | Establish ssh tunnel to pass requests to RDS Aurora (port 3306)
ssh-r | Establish an ssh tunnel to pass requests to Redshift (port 5439)

### DOCKER

Docker has various commands that do essentially the same thing. I created an abstraction that would automate and standardize the way I run the commands to make it faster to type and easier to memorize.

#### Commands - Docker

Commands start with `dk-` followed by the command suffix. Some commands also take in 1 or 2 parameters. The first parameter is the Docker entity type. The second parameter can be used to pass additional flags such as `-a` to the command.

```bash

// This lists all containers
$ dk-ls c -a
```

Value | Entity type
--- | ---
c | container
i | image
n | network
v | volume

Command suffix | Definition | Entity parameter | Additional flags parameter
--- | --- | --- | ---
ls | List entities specified | X | X
lsq | List quiet the specified entities | X |
stc | Stop all containers | |
in | Inspect entities specified | X | X
rm | Remove entities specified | X | X
rmc | Remove all containers | |
rmi | Remove all images | |
pr | Prune entities specified | X |

### TERMINAL CUSTOMIZATION

In this section, you can modify your terminal prompt using bash prompt variable. By changing the PS1 string, color values, and order of these you can specify how your terminal will look and feel. Here are some resources for more in-depth customization:

- [Bash prompt variables](https://ss64.com/bash/syntax-prompt.html)
- [Xterm color values](https://misc.flogisoft.com/bash/tip_colors_and_formatting)

## Future

I plan to keep expanding and adding to this script as I come up with other useful shortcuts. If you have feedback or suggestions please reach out via [twitter](https://twitter.com/bombillazo).
