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
    type                                # What value types are accepted for the variable, (can be left out but suggested to provide)
    default                             # Default value which then makes the variable optional, only literal
    validation                          # A block to define validation rule
    sensible                            # Limit TF UI output when the variable is used in configuration
    nullable                            # Specify if the value can be null in the module
  }
  ```
  - [Type and Values](https://developer.hashicorp.com/terraform/language/expressions/types)

    | Type                               | Description                                                     |
    |------------------------------------|-----------------------------------------------------------------|
    | **string**                          | Sequence of Unicode characters representing some text, e.g., `hello`                 |
    | **number**                          | Numeric value. Can represent both whole numbers and fractions, e.g., `12` and `6.25` |
    | **bool**                            | A boolean value of either `true` or `false`. `Bool` values can be used in conditional logic |
    | **list/tuple(string)**              | Sequence of values whose elements are identified by whole numbers starting from `0`, e.g., `['us-east-1', 'us-west-1']` |
    | **list/tuple(object)**              | Sequence of objects, e.g., `list(object({name=string, age=number}))`                 |
    | **set(type)**                       | A collection of unique values that do not have any ordering or secondary identifiers  |
    | **map(type)**                       | A group of values identified by named labels, e.g., `{name: 'bob', age=28}`         |
    | **null**                            | Absence or omission. The default value is used in conditional expressions            |

    > [!NOTE]
    > The difference between list and tuple is that list is collection type (similar types grouped together) and tuple is structural type(distinct types grouped together)
    > [!NOTE]
    > The keyword `any` may be used to indicate that any type is acceptable
    > [!NOTE]
    > `optional` modifier is used in object type constraint, to mark the attribute as optional

#### Using var flag in command execution

`-var` flag can be used to pass the input variable in the command execution in the format `terraform plan -var <variable_name>=<"value">` eg. `terraform plan -var user_uuid="212123242-sd23-fdd4-fgf5-wew233e3dd3"`

#### Using var-file flag

To set lot of variables, it is covenient to declare them in variable definition file(ending with .tfvars or .tfvars.json) and specify that file-name in the command-line

`terraform apply -var-file="testing-tfvars"`

#### Using terrform.tfvars

The default file used to load input variables. The reference in the `main.tf` is made to input variable value stored in this file

#### Using auto-tfvars

Terraform supports numbers of variable definition file types
one of them is `auto-tfvars`

#### Order of Terraform Variables

Terraform load variables in following order

![variable_precedence drawio ](https://github.com/Samba73/terraform-beginner-bootcamp-2023/assets/90577515/732603b6-c4be-43ac-af86-5b4eaed35cd8)


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

## Terraform Modules

### Terraform Module Structure

`modules` directory is created to create nested module

<img width="332" alt="Screenshot 2023-09-28 at 6 00 01 PM" src="https://github.com/Samba73/terraform-beginner-bootcamp-2023/assets/90577515/7e10be4d-424f-42ea-828b-4ee95883fbaa">


Add the following files to the module `terrahouse_aws`
- `main.tf`
- `outputs.tf`
- `variables.tf`
- `README.md`
- `LICENSE`

### Restructure the folder for module

#### `main.tf` in module

Copy the provider from the root module `providers.tf` into module's `main.tf` along with resource information in `main.tf` from root module

The `main.tf` in the module `terrahouse_aws` will look like
```tf
terraform {
#   cloud {
#     organization = "beginner-bootcamp"
#     workspaces {
#       name = "terra-house-1"
#     }
#   }
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.17.0"
    }
  }
}
 # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
 # Bucket Naming Rules
    #https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html?icmpid=docs_amazons3_console
resource "aws_s3_bucket" "website_bucket" {
  bucket = var.s3_bucket_name

  tags = {
    "Created_By" = var.user_uuid
  }
}
```
#### `outputs.tf` in module

The `outputs.tf` in the root module will not have access to the resource defined inside module. so we need to move the content of `outputs.tf` from root module to module `terrahouse_aws`
```tf
output "s3_bucket_name" {
  value = aws_s3_bucket.website_bucket
}
```
#### `variables.tf` in module

The module need variables declared within the module, hence we need to move the content of `variables.tf` from root module to module `terrahouse_aws`
```tf
variable "user_uuid" {
    description     = "The UUID of user who created to s3 bucket"
    type            = string
    validation {
      condition     = can(regex("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$", var.user_uuid))
      error_message = "The value for variable user_uuid is missing / not valid"
    }
}
variable "s3_bucket_name" {
  description = "Name of the S3 bucket"
  type        = string

  validation {
    condition     = (can(regex("^[a-z0-9.-]{3,63}$", var.s3_bucket_name)) && 
                    length(var.s3_bucket_name) >=3 && length(var.s3_bucket_name) <=63)
    error_message = "S3 bucket name must be between 3 and 63 characters, contain only lowercase letters, numbers, hyphens, and periods, and not start or end with a hyphen or period. IP address format is not allowed."
  }
}
```
> [!IMPORTANT]
> The `variables.tf` in root module cannot be left blank. This need to have at least the variable declaration for the variables used with the resource

### Restructure the root module to call the module `terrahouse_aws` 

The `main.tf` file in entry point for terraform and this file in root module need to be updated to call the module as below
```tf
module "terrahouse_aws" {
  source         = "./modules/terrahouse_aws"
  user_uuid      = var.user_uuid  
  s3_bucket_name = var.s3_bucket_name

  }
```
#### Passing input variable to module from root module
Pass the input variable as below

```tf
module "terrahouse_aws" {
  source         = "./modules/terrahouse_aws"
  user_uuid      = var.user_uuid  
  s3_bucket_name = var.s3_bucket_name

  }
```
>[!NOTE]
>The module still has to declare the variables in its own `variables.tf` file

#### Module Sources

Using the source key, modules can be imported from various places eg:
- locally
- Github
- Terraform Registry

```tf
module "terrahouse_aws" {
  source = "./modules/terrahouse_aws"
}
```
- [Modules Sources](https://developer.hashicorp.com/terraform/language/modules/sources)

#### `outputs.tf` in module

The immediate output from module will have reference to actual resource while the root module will have to refer to module output. Both the `outputs.tf` will need to be modified as below
- `outputs.tf` in module
```tf
output "s3_bucket_name" {
  value = aws_s3_bucket.website_bucket
}
```
- `outputs.tf` in root module
```tf
output "s3_bucket_name" {
  value = module.terrahouse_aws.s3_bucket_name
}
```

## Static Website Hosting

>[!NOTE]
>Considerations when using ChatGPT to write Terraform
>LLMs might give old exampled as they are not trained on latest version of details

<[!IMPORTANT]
>Always refer to documentation for example code

### Update s3 configuration for static website hosting

Add the following resource to module `main.tf` to enable s3 for static website hosting.
This will enable the s3 for static website hosting, the configuration index.html and error.html added for index and error document
```
resource "aws_s3_bucket_website_configuration" "website_configuration" {
  bucket = aws_s3_bucket.website_bucket.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}
```

### Upload `index.html` and `error.html` in s3 bucket
Upload `index.html` and `error.html` to the created resource s3 bucket.
Add the following code to module `main.tf`
```
resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "index.html"
  source = var.index_html_path
  etag = filemd5(var.index_html_path)
}
```
```
resource "aws_s3_object" "error_html" {
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "error.html"
  source = var.error_html_path
  etag = filemd5(var.error_html_path)
}
```
#### Working with Files in Terraform

We create folder structure to store these files in the root path `./public/index.html` and `./public/error.html`
The path to these files can be provided as inputs to terraform. We can validate the existence of these files in the path to ensure handling error situation where files are missing

#### Fileexists function

This is a built in terraform function to check the existance of a file.

```tf
condition = fileexists(var.error_html_filepath)
```

https://developer.hashicorp.com/terraform/language/functions/fileexists

#### Filemd5
The terraform will only compare the resource state and update the resource in the provider accordingly.
If there is change to the files (objects), then the state comparison by TF will not be identifed.
To ensure that file changes are captured in state comparison, etag can be used.
etag with fildemd5 function provided by TF will generate new etag which will be compared between states and updated in provider resource

https://developer.hashicorp.com/terraform/language/functions/filemd5

#### Path Variable

In terraform there is a special variable called `path` that allows us to reference local paths:
- path.module = get the path for the current module
- path.root = get the path for the root module
[Special Path Variable](https://developer.hashicorp.com/terraform/language/expressions/references#filesystem-and-workspace-info)


resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "index.html"
  source = "${path.root}/public/index.html"
}
