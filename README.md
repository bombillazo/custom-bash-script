# custom-bash-scripts

Series of functions, aliases and shortcuts for bash shell (running on MacOS). Each fucntion has a brief description of its functionality.

## Tools

- aws-cli
- aws-okta
- docker
- git
- python3
- terraform

### BASTION CONNECT

These commands are used to connect to a server or service through a Bastion in AWS using the ec2-instance-connect and aws-okta commands. If your case does not require Okta, you can remove the `aws-okta exec $1 --` part. The `bastion_dev` and `bastion_prod` files are used to select between 2 AWS accounts and can be modified to fit your specific setup (use the `bastion_template` file and rename it as you wish).

#### Setup

1. Fill in the `bastion_template` file with your account info.
1. Add `source /path/to/bastion_template` to your `.profile` file to have that bastion setup as the default.
1. Modify scripts to point to your environment name.

#### Commands - Bastion

The general command flow work by first pushing your public key to the bastion, then using the connect commands within a 60 second time frame to establish a connection. You can also print out the current environemnt and switch between environments (mine are setup as development and production).

Command | Definition
--- | ---
bee | Print our current bastion environment
bce | Chance bastion environment (currently hardcoded between development and production)
bkp | Push public key to bastion
ssh-a | Establish ssh tunnel to pass requests to RDS Aurora (port 3306)
ssh-r | Establish ssh tunnel to pass requests to Redshift (port 5439)

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

In this section you can modify your terminal prompt using bash prompt variable. By changing the PS1 string, color values and order of these you can specify how your terminal will look and feel. Here are some resources for more in depth customization:

- [Bash prompt variables](https://ss64.com/bash/syntax-prompt.html)
- [Xterm color values](https://misc.flogisoft.com/bash/tip_colors_and_formatting)
