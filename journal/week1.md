# Terraform Beginner Bootcamp 2023 - Week 1

## Root Module Structure

TF Root Module Structure as follow:
```
Project_ROOT
|
|-- main.tf           # primary entry point
|-- variables.tf      # stored the structure of input variables
|-- terraform.tfvars  # the data of variables to be loaded into TF project
|-- providers.tf      # defined required providers and their configurations
|-- outputs.tf        # stores the outputs
|-- README.md         # required for the root module
```

[Standard Module Structure](https://developer.hashicorp.com/terraform/language/modules/develop/structure)

## Terraform and Input Variables

### Terraform Cloud Variables

In Terraform, there are 2 kinds of variables
    - Environment Variables # eg. Provider (AWS) Env Vars (that is set in bash terminal)
    - Terraform Variables   # eg. input variables (that is set in tfvars file)

> [!NOTE]
> These variables are set as **sensitive** or **HCL**, depending on variable type
> Sensitive - not visible in UI
> HCL - allow interpolating values at runtime

### Loading Terraform Input variables

- [Terraform Input Variables](https://developer.hashicorp.com/terraform/language/values/variables#environment-variables)

#### Using var flag in command execution

`-var` flag can be used to pass the input variable in the command execution in the format `terraform plan -var <variable_name>=<"value">` eg. `terraform plan -var user_uuid="212123242-sd23-fdd4-fgf5-wew233e3dd3"`

#### Using var-file flag


#### Using terrform.tfvars

The default file used to load input variables. The reference in the `main.tf` is made to input variable value stored in this file

#### Using auto-tfvars

#### Order of Terraform Variables

## Moving state from Cloud to Local

The state preserved in cloud can be moved to local and continue to maintain the state in local for speed and ease. 
> [!NOTE]
> In this case every time the workspace is stopped, the resources need to be destroyed.

### Execute `terraform destroy` to delete the resource

The state preserved in cloud has reference so in order to remove the reference, the resources need to be destroyed

### Comment the Cloud provider in the `providers.tf` file

Comment the cloud provider in the file as below

```
terraform {
#   cloud {
#     organization = "beginner-bootcamp"
#     workspaces {
#       name = "terra-house-1"
#     }
#   }
```

### Remove the dependency files

Remove the following files that dependent on Cloud provider connectivity.
Once these files are removed, can be created with `terraform init` command execution

> [!NOTE]
> After this execution, the state reference will be **local**

 - `.terraform.locl.hcl` # this hold the hash value of the cloud provider
 - `.terraform`          # folder to be removed

 ### Execute `terraform init` command

 Execute the command to enable local state file preservance

## Handle Configuration Drift

When the Terraform Cloud is not enabled, possibilities of loosing the  state file are high. It will be challenging to recover the resources.

There are ways to import the resources and manage

[Terraform Import](https://developer.hashicorp.com/terraform/cli/import#import)

- CLI Terraform Import
- Terraform import block

### Fix missing state file with CLI Terraform Import

We have S3 created, whose state file is missing. We can do the resource import to recover the s3 resource

- [Terraform - S3 Import](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#import)

```
terraform import aws_s3_bucket.bucket bucket-name
```


### Fix manual configuration

There is possibilities that the resource(s) would be deleted or cloud resource(s) are modified through clickops.

The state file comparison by terraform enables to put the infrastructure back into original expected state by running `terraform plan`