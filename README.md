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

### Working with Env Vars

All Environment variables (Env Vars) can be listed using the `env` command.

Specific env vars can be listed using grep eg. `env | grep AWS_`

#### Setting and Unsetting Env Vars

In the terminal, set environment variable using `export PROJECT_NAME='terraform-bootcamp`

In the terminal, unset environment variable using `unset PROJECT_NAME`

Env Var can be passed to the script in execution as below (env var is temporary for script execution)
``` sh
    PROJECT_NAME='terraform-bootcamp' ./bin/print_envvar
```

Env Var can be set within the bash script (set before used in the script) as below
``` sh
    #!/usr/bin/env bash
    PROJECT_NAME='terraform-bootcamp'

    echo $PROJECT_NAME
```
#### Printing Env Vars

`echo` is used to print Env Var to console `echo $PROJECT_NAME`

#### Env Vars scope

Env Var scope is **_limited_ to the terminal window where it is set**

For global persistence of Env Vars (available for all terminal windows), Env Vars should be set in bash profile eg. `.bash_profile`

#### Persisting Env Vars in Gitpod

Env Vars in gitpod can be persisted by storing in Gitpod Secrets Storage

```
gp env PROJECT_NAME='terraform-bootcamp'
```

Since above sets Env Var at gitpod level, all workspaces launched will have the Env Var available for all terminal windows opened in the workspaces.

Env Vars can be set in `.gitpod.yml` as well, but advised to only have non-senstive data

### AWS CLI installation

AWS CLI is installed for the project via bash script `./bin/install_aws_cli`

- [Getting Started Install (AWS CLI)](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

- [Configuring AWS CLI Env Vars](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html)

Following cli command will help to check AWS credentials, it also confirms if the configuration is done and available

> [!NOTE]
> AWS CLI credentials should be generated from an IAM user in order to use to AWS CLI.

```sh
aws sts get-caller-identity
```
If after executing the above aws cli command and successful a json payload return as below

```json
{
    "UserId": "1I4A1VPP1TVGFPQCGC5L1",
    "Account": "111111111111",
    "Arn": "arn:aws:iam::111111111111:user/terraform-beginner-bootcamp"
}
```
