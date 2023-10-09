// package main: Declares the package name. This has the basic modules required to run go 
// The main package is special in Go, it's where the execution of the program starts.
// fmt is format module for I/O formatting
package main
// multiple imports can be grouped inside brackets with each import in a line
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

// func main(): Defines the main function, the entry point of the app. 
// When you run the program, it starts executing from this function.
func main(){
	plugin.Serve(&plugin.ServeOpts {
		ProviderFunc: Provider,
	})
}

type Config struct {
	Endpoint string
	Token string
	UserUuid string
}


func Provider() *schema.Provider {
	p := &schema.Provider {
		ResourcesMap: map[string]*schema.Resource{

			"terratowns_home": resourceHome(),
		},
		DataSourcesMap: map[string]*schema.Resource{},
		Schema: map[string]*schema.Schema{

			"endpoint_url": {
				Type: schema.TypeString,
				Required: true,
				DefaultFunc: schema.EnvDefaultFunc("API_ENDPOINT_URL", nil),
				Description: "The base URL of the API.",
			},
			"token": {
				Type: schema.TypeString,
				Required: true,
				Sensitive: true,
				DefaultFunc: schema.EnvDefaultFunc("TOKEN", nil),
				Description: "Bearer API authentication token.",
			},
			"user_uuid": {
				Type: schema.TypeString,
				Required: true,

				ValidateFunc: validateUUID,
				Description: "The UUID of the user.",
			},
		},

		

	}
	p.ConfigureContextFunc = configure(p)
	return p
}

func configure(p *schema.Provider) schema.ConfigureContextFunc {

	return func(ctx context.Context, d *schema.ResourceData) (interface{}, diag.Diagnostics) {
		log.Print("providerConfigure: start")
		//var diags diag.Diagnostics
		config := Config {
			Endpoint: d.Get("endpoint_url").(string),
			Token: d.Get("token").(string),
			UserUuid: d.Get("user_uuid").(string),
		}
		log.Print("providerConfigure: end")

		return &config, nil
		}
	}


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

func resourceHomeCreate(ctx context.Context, d *schema.ResourceData, m interface{}) diag.Diagnostics {
	log.Print("resourceHomeCreate: start")
	var diags diag.Diagnostics

	config := m.(*Config)

	payload := map[string]interface{}{
		"name": d.Get("name").(string),
		"description": d.Get("description").(string),
		"domain_name": d.Get("domain_name").(string),
		"town": d.Get("town").(string),
		"content_version": d.Get("content_version").(int),
	}

	payloadBytes, err := json.Marshal(payload)
	if err != nil {
		return diag.FromErr(err)
	}

	url := config.Endpoint+"/u/"+config.UserUuid+"/homes"
	log.Print("The API URL is:" + url)

	// Create HTTP request
	req, err := http.NewRequest("POST", url, bytes.NewBuffer(payloadBytes))
	if err != nil {
		return diag.FromErr(err)
	}
	//log.Print("Req Payload:" + string(req))

	// Add Header to request (from above)

	req.Header.Set("Authorization", "Bearer "+config.Token)
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("Accept", "application/json")
	
	//log.Print("Req Payload with Headers:" + req)

	client := http.Client{}
	resp, err := client.Do(req)
	log.Print(resp.Body)
	if err != nil {
		return diag.FromErr(err)
	}
	defer resp.Body.Close()

	// Read the response body

	body, err := io.ReadAll(resp.Body)

		if err != nil {
			return diag.FromErr(err)
		}
	var responseData map[string]interface{}
	
	if err := json.Unmarshal(body, &responseData); err != nil {
		return diag.FromErr(err)
	}



	if resp.StatusCode != http.StatusOK {

		return diag.Errorf("Failed to create resource. HTTP Status Code: %d, The Response Body is: %s", resp.StatusCode, string(body))
	}

	homeUUID := responseData["uuid"].(string)
	d.SetId(homeUUID)

	log.Print("resourceHomeCreate: end")

	return diags
}

func resourceHomeRead(ctx context.Context, d *schema.ResourceData, m interface{}) diag.Diagnostics {

	log.Print("resourceHomeRead: start")
	var diags diag.Diagnostics

	config := m.(*Config)

	homeUUID := d.Id()

	url := config.Endpoint+"/u/"+config.UserUuid+"/homes/"+homeUUID
	log.Print("The API URL is:" + url)

	// Create HTTP request
	req, err := http.NewRequest("GET", url, nil)
	if err != nil {
		return diag.FromErr(err)
	}
	//log.Print("Req Payload:" + string(req))

	// Add Header to request (from above)

	req.Header.Set("Authorization", "Bearer "+config.Token)
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("Accept", "application/json")
	
	//log.Print("Req Payload with Headers:" + req)

	client := http.Client{}
	resp, err := client.Do(req)

	if err != nil {
		return diag.FromErr(err)
	}
	defer resp.Body.Close()

	// Read the response body

	body, err := io.ReadAll(resp.Body)

		if err != nil {
			return diag.FromErr(err)
		}
	var responseData map[string]interface{}
	
	if resp.StatusCode == http.StatusOK {

		if err := json.Unmarshal(body, &responseData); err != nil {
			return diag.FromErr(err)
		}

		d.Set("name", responseData["name"].(string))
		d.Set("description", responseData["description"].(string))
		d.Set("content_version", responseData["content_version"].(float64))
		d.Set("town", responseData["town"].(string))
		d.Set("domain_name", responseData["domain_name"].(string))

	} else if resp.StatusCode != http.StatusNotFound {
		d.SetId("")
	} else if resp.StatusCode != http.StatusOK {	
		return diag.Errorf("Failed to create resource. HTTP Status Code: %d, The Response Body is: %s", resp.StatusCode, string(body))
	}

	log.Print("resourceHomeRead: end")

	return diags

}

func resourceHomeUpdate(ctx context.Context, d *schema.ResourceData, m interface{}) diag.Diagnostics {

	log.Print("resourceHomeUpdate: start")
	var diags diag.Diagnostics

	config := m.(*Config)

	homeUUID := d.Id()

	payload := map[string]interface{}{
		"name": d.Get("name").(string),
		"description": d.Get("description").(string),
		"content_version": d.Get("content_version").(int),
	}

	payloadBytes, err := json.Marshal(payload)
	if err != nil {
		return diag.FromErr(err)
	}

	url := config.Endpoint+"/u/"+config.UserUuid+"/homes/"+homeUUID
	log.Print("The API URL is:" + url)

	// Create HTTP request
	req, err := http.NewRequest("PUT", url, bytes.NewBuffer(payloadBytes))
	if err != nil {
		return diag.FromErr(err)
	}
	//log.Print("Req Payload:" + string(req))

	// Add Header to request (from above)

	req.Header.Set("Authorization", "Bearer "+config.Token)
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("Accept", "application/json")
	
	//log.Print("Req Payload with Headers:" + req)

	client := http.Client{}
	resp, err := client.Do(req)

	if err != nil {
		return diag.FromErr(err)
	}
	defer resp.Body.Close()

	// Read the response body

	
	if resp.StatusCode != http.StatusOK {

		return diag.Errorf("Failed to create resource. HTTP Status Code: %d", resp.StatusCode)
	}

	log.Print("resourceHomeUpdate: end")
	d.Set("name", payload["name"].(string))
	d.Set("description", payload["description"].(string))
	d.Set("content_version", payload["content_version"].(int))
	return diags

}

func resourceHomeDelete(ctx context.Context, d *schema.ResourceData, m interface{}) diag.Diagnostics {


	log.Print("resourceHomeDelete: start")
	var diags diag.Diagnostics

	config := m.(*Config)

	homeUUID := d.Id()

	url := config.Endpoint+"/u/"+config.UserUuid+"/homes/"+homeUUID
	log.Print("The API URL is:" + url)

	// Create HTTP request
	req, err := http.NewRequest("DELETE", url, nil)
	if err != nil {
		return diag.FromErr(err)
	}
	//log.Print("Req Payload:" + string(req))

	// Add Header to request (from above)

	req.Header.Set("Authorization", "Bearer "+config.Token)
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("Accept", "application/json")
	
	//log.Print("Req Payload with Headers:" + req)

	client := http.Client{}
	resp, err := client.Do(req)

	if err != nil {
		return diag.FromErr(err)
	}
	defer resp.Body.Close()

		if resp.StatusCode != http.StatusOK {
		return diag.Errorf("Failed to create resource. HTTP Status Code: %d", resp.StatusCode)
	}

	d.SetId("")

	log.Print("resourceHomeDelete: end")

	return diags

}

