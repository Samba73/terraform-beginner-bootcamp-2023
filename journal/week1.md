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

In Terraform, there are 3 kinds of variables

    - Environment Variables # eg. Provider (AWS) Env Vars (that is set in bash terminal)
    - Terraform Variables   # eg. input variables (that is set in tfvars file)
    - Expression Variables  # eg. conditional expression used to indirectly represent a value in an expression
    
> [!NOTE]
> These variables are set as **sensitive** or **HCL**, depending on variable type
> Sensitive - not visible in UI
> HCL - allow interpolating values at runtime

### Loading Terraform Input variables

- [Terraform Input Variables](https://developer.hashicorp.com/terraform/language/values/variables)

  Format is
  ```
  variable <variable_name> {
    description                         # Text to describe the varaible
    type                                # What value types are accepted for the variable
    default                             # Default value which then makes the variable optional
    validation                          # A block to define validation rule
    sensible                            # Limit TF UI output when the variable is used in configuration
    nullable                            # Specify if the value can be null in the module
  }
 ```

  Type Constraints
  - string
  - number
  - bool
  - list(<type>)    # list(string)/ list(object)/ list(
  - set(<type>)     #
  - map(<type>)     #
  - object({<ATTRB_NAME>=<type>,...})
  - tuple([<type>,...])

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
