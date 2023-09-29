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

>[!IMPORTANT]
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

## CloudFront (CDN) Implementation

CloudFront (CDN) is Content Delivery Network that uses edge locations to reduce latency and provide content to end users.
S3 can be source for CDN and S3 (through s3 bucket policy) can have Origin Access Control to allow only CF (CDN) to have access to its content for delivery

### Restructure the folder

with more resources added `main.tf` in module can get bulky, so the storage and cdn can be separated into its own `.tf` file

Create `resource-storage.tf` for s3 declaraltion and `resource-cdn.tf` for clodoufront distribution

#### `resource-storage.tf` updates
Move the s3 resource declaration from `main.tf` in module to `resource-storage.tf`

### Create cloudfront distribution
[Terraform CF Distribution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution#domain_name)

#### Update `resource-cdn.tf` file

The cloudfront distribution resource need to be created. Following is the format
```
resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = aws_s3_bucket.website_bucket.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.default.id
    origin_id                = local.s3_origin_id
  }

  enabled                    = true
  is_ipv6_enabled            = true
  comment                    = "Static Website Hosting for ${var.s3_bucket_name}"
  default_root_object        = "index.html"

  #aliases = ["mysite.example.com", "yoursite.example.com"]

  default_cache_behavior {
    allowed_methods          = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods           = ["GET", "HEAD"]
    target_origin_id         = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  tags = {
    userUUID = var.user_uuid
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
```
#### Update `resource-cdn.tf` to add origin access control (OAC)
Origin Access Control enables access control to s3 bucket and its content. When CloudFront is used, it can be set as the only service that can access s3 through s3 bucket policy

```
resource "aws_cloudfront_origin_access_control" "default" {
  name                              = "OAC ${var.s3_bucket_name}"
  description                       = "Origin Access Control for Static Website Hosting ${var.s3_bucket_name}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}
```
#### Terraform Locals

Locals allows us to define local variables.
It can be very useful when we need transform data into another format and have referenced a varaible.

```tf
locals {
  s3_origin_id = "MyS3Origin"
}
```
[Local Values](https://developer.hashicorp.com/terraform/language/values/locals)

### Add S3 Bucket Policy
S3 bucket policy need to be added that will enable to OAC to be activated. In the policy only cloudfront service will be allowed as principal to access the s3 and its content
```
resource "aws_s3_bucket_policy" "cf_bucket_policy" {
  bucket = aws_s3_bucket.website_bucket.id
  policy = jsonencode(
    {
    "Version": "2012-10-17",
    "Statement": {
        "Sid": "AllowCloudFrontServicePrincipalReadOnly",
        "Effect": "Allow",
        "Principal": {
            "Service": "cloudfront.amazonaws.com"
        },
        "Action": "s3:GetObject",
        "Resource": "arn:aws:s3:::${aws_s3_bucket.website_bucket.id}/*",
        "Condition": {
            "StringEquals": {
                # "AWS:SourceArn": "arn:aws:cloudfront::<AWS account ID>:distribution/<CloudFront distribution ID>"
                "AWS:SourceArn": aws_cloudfront_distribution.s3_distribution.arn
            }
        }
    }
}
  )
}
```
>[!NOTE]
>The `SourceArn` above in the condition for s3 bucket policy can also indirectly assign the CDN distribution through `"AWS:SourceArn": "arn:aws:cloudfront::<AWS account ID>:distribution/<CloudFront distribution ID>"` but we need to pass the AWS AccountID and CDN  Distribution id

#### Terraform Data Sources

This allows use to source data from cloud resources.

This is useful when we want to reference cloud resources without importing them.

```tf
data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}
```
[Data Sources](https://developer.hashicorp.com/terraform/language/data-sources)

#### Working with JSON for s3 bucket policy

jsonencode is used to create the json policy inline in the hcl.

```tf
> jsonencode({"hello"="world"})
{"hello":"world"}
```

[jsonencode](https://developer.hashicorp.com/terraform/language/functions/jsonencode)

## Setup Content Version

### Changing Lifecycle of resources

In the previous (issue # 29) the `etag = filemd5(var.index_html_path)` set the changes to be applied whenever the content of the resource is changed.
This is not intended usage. Instead of every change to the content of the resource to be applied, this can be controlled through variable (content_version).

- [Terraform Lifecycle](https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle)

Update the lifecyle as below to avoid `etag` changes

```
lifecyle {
    ignore_changes=[etag]
}
```
### Create `terraform_data` resource 

Plain data values such as Local Values and Input Variables don't have any side-effects to plan against and so they aren't valid in replace_triggered_by. You can use terraform_data's behavior of planning an action each time input changes to indirectly use a plain value to trigger replacement.

- [Terraform Data](https://developer.hashicorp.com/terraform/language/resources/terraform-data)

  ```
  resource "terraform_data" "content_version" {
  input = var.content_version
}

### Create variable to control resource content changes to be applied
Create variable in module as below
```
variable "content_version" {
  description = "A positive integer starting from 1"
  type        = number

  validation {
    condition     = var.content_version > 0 && floor(var.content_version) == var.content_version
    error_message = "The value must be a positive integer starting from 1."
  }
}
```
Make the required changes in following files
- `variables.tf` in root module
- `terraform.tfvars` in root module to declare and assign value to variable
- `main.tf` in root module to pass the variable

### Reference to `terraform_data` in resource to trigger the changes being applied
 Refer to `terraform_data` output in resource section to enable triggering the changes to be applied when there is change to the declared variable `content_version`

 ```
resource "aws_s3_object" "index_html" {
  bucket        = aws_s3_bucket.website_bucket.bucket
  key           = "index.html"
  source        = var.index_html_path
  content_type  = "text/html"
  etag          = filemd5(var.index_html_path)
  lifecycle {
    replace_triggered_by = [terraform_data.content_version.output]
    ignore_changes = [etag]
  }
}
resource "aws_s3_object" "error_html" {
  bucket        = aws_s3_bucket.website_bucket.bucket
  key           = "error.html"
  source        = var.error_html_path
  content_type  = "text/html"
  etag          = filemd5(var.error_html_path)
}
