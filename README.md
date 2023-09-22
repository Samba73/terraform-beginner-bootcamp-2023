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
## Terraform Basics

### Terraform Registry

Terraform sources their providers and modules from the Terraform registry which located at [registry.terraform.io](https://registry.terraform.io/)

- **Providers** are Terraform plugins that enables interaction with API (Cloud Providers). They tell Terraform with which services it need to interact.
- **Modules** are any Terraform configuration file (.tf) in a directory, even just one, forms a module. Module allows to group resources together and reuse this group later, possibly many times.  

- [Random Terraform Provider](https://registry.terraform.io/providers/hashicorp/random/latest)

### Terraform Console

We can see a list of all the Terraform commands by simply typing `terraform`

#### Terraform Init

At the start of a new terraform project `terraform init` will be executed to download the binaries for the terraform providers that will be used.

#### Terraform Plan

`terraform plan`

This will generate out a changeset, about the state of infrastructure and what will be changed.

This changeset can can be setn to apply, but often ignored.

#### Terraform Apply

`terraform apply`

This will run a plan and pass the changeset to be executed by terraform. Apply should prompt user for confirmation to proceed (Yes or No).

There is option that can be included in the apply to auto approve the confirmation `terraform apply --auto-approve`

#### Terraform Destroy

- `terraform destroy` will be executed to destroy the resource(s).
- `terraform destroy --auto-approve` will be executed to destroy the resource(s) without waiting for user confirmation

### Terraform Folder Structure
#### Terraform Lock Files

`.terraform.lock.hcl` contains the locked versioning for the providers or modules that should be used.

> [!IMPORTANT]
> The Terraform Lock File should be committed to Version Control System (VCS) eg. GitHub

#### Terraform State Files

- `.terraform.tfstate` contains information about the current state of the infrastructure.

> [!IMPORTANT]
> This file should not be committed to Version Control System (VCS)
> This file contain sensitive data, the state of infrasturucture will be unknown if this file is lost

- `.terraform.tfstate.backup` is the previous state file state.

#### Terraform Directory
- `.terraform` directory contains binaries of terraform providers.

### Terraform - AWS : Create a Simple S3 Bucket

#### Add AWS provider to Terraform

- [AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- Add the following provider to terraform file `main.tf`
```
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.17.0"
    }
  }
}
```
> [!NOTE]
> There can be only one terrform & required_providers section in the `main.tf` file
> If there is already required_providers section, only add the aws portion to the required_providers section

#### Configure the AWS provider
AWS credentials can be provided using Env Vars in which case the AWS Configure section can be as below
```
provider "aws" {}

```

#### Configure and Define the random string resource 
The random string resource should be configured to match the S3 naming rules of **no upper case character**, **minimun 3 characters length** and **no special character**

```
resource "random_string" "bucket_name" {
  length           = 16
  special          = false
  upper            = false 
}
```

#### Define S3 resource
Define the S3 resource with bucket name as string generated by random string resource in previous step like below
```
resource "aws_s3_bucket" "example" {
  bucket = "samba07-tf-${random_string.bucket_name.result}"
}
```

#### Execute Terraform Plan
Execute the command `terraform plan` to view and confirm the changeset

#### Execute Terraform apply
Execute the command `terraform apply` or `terraform apply --auto-approve` to create the bucket with the name generated by random string resource

#### Confirm the S3 bucket in AWS
Navigate to S3 console and confirm the S3 created with the same name as expected

#### Delete the S3 bucket in AWS
Execute command `terraform destroy` or `terraform destroy --auto-appprove` to delete the S3 bucket

#### Confirm the S3 bucket deletion
Navigate to S3 console and confirm the S3 is deleted

### Terraform Cloud - Move local state to remote state

The state file in local can be stored in Terraform cloud

#### Configure Terraform Cloud Backend

- Register and login to Terraform Cloud
- Create a new Organization (eg. *beginner-bootcamp*)
- Create a new Project (eg. *terraform-beginner-bootcamp-2023*)
- Create a new Workspace (eg. *terra-house-1*)
- Add the following config to `main.tf` file
 ```
  cloud {
    organization = "beginner-bootcamp"
    workspaces {
      name = "terra-house-1"
    }
  }
```

#### Terraform Init

Execute command `terraform init`
> [!WARNING]
> Executing `terraform init` will display warning to login to terraform cloud using `terraform login`

#### Terraform Login
Execute the command `terraform login`

This will launch bash terminal with below options

- [ ] P for Print
- [x] G for Go
- [ ] M for Main Page
- [ ] Q for Quit

- Selecting `G` option, will provide link, navigate to the [link](https://app.terraform.io/app/settings/tokens?source=terraform-login) and generate token.
- As soon as token is generated, the terminal will provide input option to enter generated token
- Enter the token, the login will be validated
> [!NOTE]
> If the login is not validated, create open the file manually
 ```sh
  touch /home/gitpod/.terraform.d/credentials.tfrc.json
  open /home/gitpod/.terraform.d/credentials.tfrc.json
```
 Provide the following code
```
  {
    "credentials": {
      "app.terraform.io": {
        "token": "YOUR-TERRAFORM-CLOUD-TOKEN"
      }
    }
  }
```
- Execute `terraform init`
- Execute `terrafom apply`

> [!WARNING]
> If the Env Vars are not set for Terraform Cloud, executing `terraform apply` will display error indicating missing authentication

- Provide the AWS credentials to Terraform Cloud either in terraform cloud GUI (or) add Env Vars in `main.tf` under Configure the AWS Provider

> [!NOTE]
> When providing Env Vars for Terraform Cloud in `main.tf` file, ensure to add **TF_VAR** before the Env Var name eg. *TF_VAR_AWS_ACCESS_KEY_ID*

#### Terraform Apply

- The resource (S3) will be successfully created, and the Terraform Cloud will have state saved 
- It will also show the resource(s) created

> [!IMPORTANT]
> The tedious `terraform login` process can be simplified by a bash script [bin/generate_tfrc_credentials](bin/generate_tfrc_credentials)


