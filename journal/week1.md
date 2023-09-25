# Terraform Beginner Bootcamp 2023 - Week 1

## Root Module Structure

TF Root Module Structure as follow:
```
Project_ROOT
|--
|-- main.tf           # primary entry point
|-- variables.tf      # stored the structure of input variables
|-- terraform.tfvars  # the data of variables to be loaded into TF project
|-- providers.tf      # defined required providers and their configurations
|-- outputs.tf        # stores the outputs
|-- README.md         # required for the root module
```
```
Project_ROOT
├── variables.tf - stored the structure of input variables
├── main.tf - root module
├── providers.tf - defined required providers and their configurations
├── outputs.tf - stores the outputs
├── terraform.tfvars - the data of variables to be loaded into TF project
└── README.md - required for the root module
```
[Standard Module Structure](https://developer.hashicorp.com/terraform/language/modules/develop/structure)
