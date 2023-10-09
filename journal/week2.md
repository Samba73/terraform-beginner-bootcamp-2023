# Terraform Beginner Bootcamp 2023 - Week 2

## Working with Ruby

### Bundler

Bundler is a package manager for runy.
It is the primary way to install ruby packages (known as gems) for ruby.

#### Install Gems

You need to create a Gemfile and define your gems in that file.

```rb
source "https://rubygems.org"

gem 'sinatra'
gem 'rake'
gem 'pry'
gem 'puma'
gem 'activerecord'
```

Then you need to run the `bundle install` command

This will install the gems on the system globally (unlike nodejs which install packages in place in a folder called node_modules)

A Gemfile.lock will be created to lock down the gem versions used in this project.

#### Executing ruby scripts in the context of bundler

We have to use `bundle exec` to tell future ruby scripts to use the gems we installed. This is the way we set context.

### Sinatra

Sinatra is a micro web-framework for ruby to build web-apps.

Its great for mock or development servers or for very simple projects.

You can create a web-server in a single file.

https://sinatrarb.com/

## Terratowns Mock Server

### Running the web server

We can run the web server by executing the following commands:

```rb
bundle install
bundle exec ruby server.rb
```

All of the code for our server is stored in the `server.rb` file.

## Creating a Custom Provider in Go for Terraform
Following is step-by-step instruction on creating a custom provider in Go for Terraform. 

[Writing Customer Provier](https://www.hashicorp.com/blog/writing-custom-terraform-providers)

Custom providers allow you to extend Terraform's functionality by integrating with external APIs or services that are not natively supported.

In this section, we'll create a custom provider called `terratowns`. This provider will manage "TerraTown" where `terra house` is created in a fictional service. 

Follow these steps to create your custom provider:

- [x] Prerequisites:

- Go packages are installed in Gitpod by default, so there is no pre-requisite to install Go packages

### Step 1: Set up your development environment
Create a new directory for your custom provider and navigate to it:

```bash
mkdir `terraform-provider-terratowns`
> [!NOTE]
> The naming should be `terraform-provider-<name of choice>`
> 
cd terraform-provider-terratowns
Create a file `main.go`
```
### Step 3: Create the Provider Skeleton

Edit `main.go` to include implementation for custom provider

#### Implement Imports
```
package main

import (
    "log"
    "fmt"
    "bytes"
    "regexp"
    "context"
    "net/http"
    "io"
    "encoding/json"
    "github.com/google/uuid"
    "github.com/hashicorp/terraform-plugin-sdk/v2/diag"
    "github.com/hashicorp/terraform-plugin-sdk/v2/plugin"
    "github.com/hashicorp/terraform-plugin-sdk/v2/helper/schema"
)
```

#### Define the main function 

The main.go file is the entry point of the custom Terraform provider. It sets up the provider configuration, initializes the necessary resources, and starts the provider's main loop. 
It typically handles the initialization of logging, configuration parsing, and registering the provider's resources and data sources.

- main() is the entry point for your provider binary
- plugin.Serve is a function that sets up the provider for use with Terraform. It takes an argument of type *plugin.ServeOpts
- ProviderFunc is a function that returns an instance of your custom Terraform provider. In this case, it returns the Provider function
```
func main(){
	plugin.Serve(&plugin.ServeOpts {
		ProviderFunc: Provider,
	})
}
```
#### Define Config Struct
Config is a custom struct that represents the configuration options for your provider. 
It includes three fields: 
 - Endpoint
 - Token
 -  UserUuid
these correspond to the configuration settings specified by Terraform users.package exampleprovider
```
type Config struct {
    Endpoint string
    Token    string
    UserUuid string
}
```
#### Provider function
Provider is a function that defines your custom Terraform provider.
Inside the provider definition:
- ResourcesMap is a map that associates resource names (e.g., "terratowns_home") with their corresponding resource configurations
- DataSourcesMap is currently empty, but you can define data sources here if your provider needs them

Schema defines the configuration options (schema) for your provider. Each option is specified as a key-value pair in the map. 
Here, there are three options: endpoint_url, token, and user_uuid. For each option, you define its type, whether it's required, its default value (using environment variables if available), and a description.
- configure(p) sets the ConfigureContextFunc to handle provider configuration. This function is called to process and validate user-provided configuration values
```
func Provider() *schema.Provider {
    p := &schema.Provider{
        ResourcesMap: map[string]*schema.Resource{
            "terratowns_home": resourceHome(),
        },
        DataSourcesMap: map[string]*schema.Resource{},
        Schema: map[string]*schema.Schema{
            "endpoint_url": {
                Type:        schema.TypeString,
                Required:    true,
                DefaultFunc: schema.EnvDefaultFunc("API_ENDPOINT_URL", nil),
                Description: "The base URL of the API.",
            },
            "token": {
                Type:        schema.TypeString,
                Required:    true,
                Sensitive:   true,
                DefaultFunc: schema.EnvDefaultFunc("TOKEN", nil),
                Description: "Bearer API authentication token.",
            },
            "user_uuid": {
                Type:        schema.TypeString,
                Required:    true,
                ValidateFunc: validateUUID,
                Description: "The UUID of the user.",
            },
        },
    }

    // Set the configuration function to handle provider configuration
    p.ConfigureContextFunc = configure(p)

    return p
}
```
#### Add validation to schema objects
Below are the validations added to provider schema objects UUID

```
func validateUUID(v interface{}, s string) (ws []string, errors []error){
	log.Print("validateUUID: start")

	value := v.(string)

	_, err := uuid.Parse(value)

	if err != nil {
		errors = append(errors, fmt.Errorf("%s is not a valid user UUID", value))
	}

	log.Print("validateUUID: end")
	return
}
```
#### Configure Function
configure is a function that takes a schema.Provider as an argument and returns a schema.ConfigureContextFunc.
The returned ConfigureContextFunc is a function that actually processes the configuration data provided by Terraform users. It extracts the values for endpoint_url, token, and user_uuid from the schema.ResourceData object and stores them in a Config struct.
It returns the populated Config struct and nil for diagnostics (error), indicating a successful configuration.

In summary, this code defines a custom Terraform provider called "terratowns" with three configuration options. When users configure this provider in their Terraform configurations, the configure function is called to extract and validate the configuration values, which are then used as needed by your provider implementation to interact with external resources or APIs.
```
func configure(p *schema.Provider) schema.ConfigureContextFunc {
    return func(ctx context.Context, d *schema.ResourceData) (interface{}, diag.Diagnostics) {
        log.Print("providerConfigure: start")
        //var diags diag.Diagnostics
        config := Config{
            Endpoint: d.Get("endpoint_url").(string),
            Token:    d.Get("token").(string),
            UserUuid: d.Get("user_uuid").(string),
        }
        log.Print("providerConfigure: end")

        return &config, nil
    }
}
```
#### Configure Customer Provider Resource & its Schema
Define schemas for your resources in resourceHome() function.
CRUD - Create Read Update Delete are mandatory for custom provider
The following code shows the resource schema defining the 4 CRUD operation through function calls
```
func resourceHome() *schema.Resource {
	log.Print("Resource: start")
	resource := &schema.Resource{
		CreateContext: resourceHomeCreate,
		ReadContext: resourceHomeRead,
		UpdateContext: resourceHomeUpdate,
		DeleteContext: resourceHomeDelete,
		Schema: map[string]*schema.Schema{
			"name": {
				Type: schema.TypeString,
				Required: true,
				Description: "Name of home",
			},
			"description": {
				Type: schema.TypeString,
				Required: true,
				Description: "Description of home",
			},
			"domain_name": {
				Type: schema.TypeString,
				Required: true,
				ValidateFunc: validateCloudFrontDomainName,
				Description: "Domain name of home eg. *.cloudfront.net",
			},
			"town": {
				Type: schema.TypeString,
				Required: true,
				ValidateFunc: validateTown,
				Description: "The town to which the home will belong to",
			},
			"content_version": {
				Type: schema.TypeInt,
				Required: true,
				Description: "The content version of the home",
			},
		},

	}
	log.Print("Resource: end")
	return resource

}
```
#### Add validation for resource schema objects

Following validation functions were created to validate resource schema objects of domain name, town
The `terraform plan` or `terraform apply` will validate these schema objects with the provided validations and display in terminal. The validations has to pass before the changes can be applied
```
func validateTown(v interface{}, t string) (ws []string, errors []error){
	value := v.(string)

	validTowns := map[string]bool {
		"melomaniac-mansion": true,
        "cooker-cove":        true,
        "video-valley":       true,
        "the-nomad-pad":      true,
        "gamers-grotto":      true,
		"missingo":			  true,	
	}

	if !validTowns[value] {
		errors = append(errors, fmt.Errorf("%s is not a valid Town to associate", value))
	}
	return
}


func validateCloudFrontDomainName(v interface{}, k string) (ws []string, errors []error){
	value := v.(string)

	pattern  := `^[a-zA-Z0-9-]+\.cloudfront\.net$`

	match, _ := regexp.MatchString(pattern, value)

	if !match {
		errors = append(errors, fmt.Errorf("%s is not a valid AWS Cloudfront domain name", value))
	}
	return
}
```
### Create Operation in CRUD

#### Function Signature
`resourceHomeCreate` is a function that takes three arguments:
- ctx: A context.Context object for handling timeouts and cancellations
- d: A schema.ResourceData object representing the Terraform resource being created
- m: An interface that holds the provider configuration (an instance of *Config)
- diag is return of the function which is diagnostics (error) 

```func resourceHomeCreate(ctx context.Context, d *schema.ResourceData, m interface{}) diag.Diagnostics {```
#### Initialize Diagnostics and Configuration:
- This code initializes a diag.Diagnostics variable (diags) to store diagnostic information, which can be used to report errors or warnings back to Terraform
- It also extracts the provider configuration stored in m and type-asserts it to the *Config type
```
log.Print("resourceHomeCreate: start")
var diags diag.Diagnostics
config := m.(*Config)
```
#### Create Payload
This code creates a payload map that contains the data to be sent in the HTTP request body. The data is obtained from the resource's attributes (d.Get) and is type-asserted to the expected types (string and int).
```
payload := map[string]interface{}{
    "name":           d.Get("name").(string),
    "description":    d.Get("description").(string),
    "domain_name":    d.Get("domain_name").(string),
    "town":           d.Get("town").(string),
    "content_version": d.Get("content_version").(int),
}
```
#### JSON Serialization of Payload
The payload map is serialized to JSON format using json.Marshal. If there's an error during serialization, it's converted into a diagnostic and returned.
```
payloadBytes, err := json.Marshal(payload)
if err != nil {
    return diag.FromErr(err)
}
```
#### Create and Configure HTTP Request
The API endpoint URL is constructed based on the provider configuration.
An HTTP POST request is created with the URL and payload.
```
url := config.Endpoint + "/u/" + config.UserUuid + "/homes"
req, err := http.NewRequest("POST", url, bytes.NewBuffer(payloadBytes))
if err != nil {
    return diag.FromErr(err)
}
```
#### Set Request Headers
Headers such as Authorization, Content-Type, and Accept are set for the HTTP request
```
req.Header.Set("Authorization", "Bearer "+config.Token)
req.Header.Set("Content-Type", "application/json")
req.Header.Set("Accept", "application/json")
```
#### Send HTTP request
The HTTP request is sent, and the response is stored in resp. Any error during the request is converted into a diagnostic.

```
client := http.Client{}
resp, err := client.Do(req)
if err != nil {
    return diag.FromErr(err)
}
```
#### Read and Parse Response
The response body is read and then unmarshaled from JSON into a map[string]interface{} to extract data from the response.
```
body, err := ioutil.ReadAll(resp.Body)
if err != nil {
    return diag.FromErr(err)
}

var responseData map[string]interface{}
if err := json.Unmarshal(body, &responseData); err != nil {
    return diag.FromErr(err)
}

```
### Check Reponse Status code and Set ResourceID
If the HTTP status code is not 201 Created, an error diagnostic is returned, indicating the failure and providing information about the status code and response body.
If the resource creation was successful, the UUID of the newly created resource is extracted from the response and set as the Terraform resource's ID using d.SetId.
```
if resp.StatusCode != http.StatusCreated {
    return diag.Errorf("Failed to create resource. HTTP Status Code: %d, The Response Body is: %s", resp.StatusCode, string(body))
}
```
```
homeUUID := responseData["uuid"].(string)
d.SetId(homeUUID)
```
```
log.Print("resourceHomeCreate: end")
return diags
```
