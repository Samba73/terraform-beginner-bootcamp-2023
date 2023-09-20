# Terraform Beginner Bootcamp 2023

## Semantic Versioning :mage:

This project is going to utilize [semantic versioning](https://semver.org/) for its tagging.

The general format:

**MAJOR.MINOR.PATCH**, eg. `1.0.1`

- **MAJOR** version when you make incompatible API changes
- **MINOR** version when you add functionality in a backward compatible manner
- **PATCH** version when you make backward compatible bug fixes


## Install the Terraform CLI

### Considerations with the Terraform CLI changes
The terraform CLI installation instructions have changed due to gpg keyring changes. So there was need to refer to latest install CLI instructions via Terraform Documentation and change the scripting for install.

- [Install Terraform CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

### Considerations for Linux Distribution

This project is built against Ubuntu.

Please consider checking your Linux distribution and change accordingly to match distribution needs.

- [Check OS version in Linux](https://www.cyberciti.biz/faq/how-to-check-os-version-in-linux-command-line/)

Example of checking OS Version: 

```
$ cat /etc/os-release

PRETTY_NAME="Ubuntu 22.04.3 LTS"
NAME="Ubuntu"
VERSION_ID="22.04"
VERSION="22.04.3 LTS (Jammy Jellyfish)"
VERSION_CODENAME=jammy
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=jammy
```
### Refactoring into Bash Scripts

While fixing the Terraform CLI gpg deprecation issues, the latest install instructions had more code and was suitable situation for creating a bash scripts which help to maintain the scripts in single bash script.

The bash script is located here: [./bin/install_terraform_cli](./bin/install_terraform_cli)

- This will help to keep Gitpod task file ([.gitpod.yml](gitpod.yml)) tidy. 
- This allow easy code maintenance and easy to debug / execute
- This will allow better portability for other requirements

#### Shebang Considerations

A Shebang (pronounced Sha-bang) tells the bash script how the script will be interpreted. eg. `#!/bin/bash`

ChatGPT recommended the below format for bash: `#!/usr/bin env bash`

- for portability for different Linux distribution
- will search the user's PATH for the correct bash executable

- [Shebang reference](https://en.wikipedia.org/wiki/Shebang_(Unix))

#### Execution Considerations

When executing the bash script we can use the `./` shorthand notation to execute the bash script.

eg. `./bin/install_terraform_cli`

If we are using a script in .gitpod.yml we need to point the script to a program to interpret it.

eg. `source ./bin/install_terraform_cli`

#### Linux Permissions Considerations

In Order oto make our bash scripts executable we need to change linux permission for the fix to be executable at user mode.
```sh
chmod u+x ./bin/install_terraform_cli
```
Alternatively we can use corresponding numbers to provide permission

```sh
chmod 744 ./bin/install_terraform_cli
```
- [Script Permission](https://en.wikipedia.org/wiki/Chmod)

### Gitpod Workspace Lifecyle (Before,Init, Command)

Careful consideration should be given using Init in the `.gitpod.yml` because it will not rerun this when existing workspace is started.

- [Gitpod Tasks](https://www.gitpod.io/docs/configure/workspaces/tasks)