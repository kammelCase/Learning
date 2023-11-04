Version v0.1.0
<!-- BEGIN_TF_DOCS -->
# Create Virtual Networks
This module allows you to provision one or more Virtual Networks in Microsoft Azure.

## Changelog

-   Version `v0.1.0`
    * Published artifact name: `virtualnetwork` 
    * Published artifact version: `v0.1.0`
    * First release of 0.1.0
    ---

## Includes
-   main.tf
-   variables.tf
-   output.tf
-   README.tf
-   versions.tf
-   example/main.tf
-   example/provider.tf
-   example/virtualnetwork-publish.yaml
-   example/var-virtualnetwork.auto.tfvars

## Features:
-   Create one or more virtual networks

## How to use?
* Azure DevOps:
    1. Copy `var-{module.name}.auto.tfvars` file in environment folder of your repository/branch. 
    2. Rename it to `var-${tfvars_file_name}.auto.tfvars` if required.
    3. Modify values of the attributes if required. And commit changes if any.
    4. Go-to `Pipline.{env}.yaml` file and add resource block if it is not there. And commit changes.
    5. Execute the pipeline by selecting `{tfvars_file_name}_plan` or `{tfvars_file_name}_apply` or both.
    
    ---

* GitLab:
    1. Copy contains of `example/main.tf` file
    2. Open gitlab. Move to required `{organization}/{project}/{subproject}/{dir_if_any}`.
    3. Create a new file say `main.tf`. Paste what you copied from `example/main.tf`
    4. Check source and modify value of attributes if required. Commit changes.
    5. Create a new file `provider.tf` in same directory and paste the contains of `example/provider.tf` there.
    6. Make required changes in `.gitlab-ci.yml` file and execute the pipeline.
    
    ---

* Local:
    1. Clone the repo to local.
    2. Make sure to setup terraform and environment paths correctly
    3. (For testing module) Open terminal inside example folder and run terraform commands provided below. (change `source = "../"`)
    4. (For using this module) Copy code from the example/main.tf, give path to the module in "source".
    6. Modify value of attributes if required.
    5. In same directory where module is being called, open terminal and run terraform commands provided below.
    6. Terraform commands: `terraform init` -> `terraform plan` -> `terraform apply`

    ---


## Requirements
| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | `1.1.9` |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | `3.3.0` |

## Module Dependency

* Module "resourcegroup" ("./modules/iac-tf-module-az-resource-group")

## Security Controls

| CATEGORY | SECURITY STANDARD        | SECURITY DEFINITION                                                                    | REQUIRED?   |
| -------- | ------------------------ | -------------------------------------------------------------------------------------- | ----------- |
| Security | DDoS Protection Standard | provides enhanced DDoS mitigation features to defend against DDoS attacks              | Recommended    |
| Tags     | Tags                     | Ensure mandatory tags are provided as per client requirements                          | Recommended |

## Resources

| Name | Type |
|------|------|
| [azurerm_virtual_network.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_virtual_networks"></a> [virtual\_networks](#input\_virtual\_networks) | The virtual networks with their properties/configurations. | <pre>map(object({<br>    vnet_name                  = string<br>resource_group_name               = string<br>    address_space           = list(string)<br>    dns_servers             = list(string)<br>    bgp_community           = string<br>    flow_timeout_in_minutes = number<br>    ddos_protection_plan    = list(object({<br>        id = string<br>        enable = bool<br>    }))<br>  }))</pre> | `{}` | no |
| <a name="input_vnet_additional_tags"></a> [vnet\_additional\_tags](#input\_vnet\_additional\_tags) | Additional tags for virtual networks. | `map(string)` | `{}` | no |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Primary subscription ID | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vnet_ids"></a> [vnet\_ids](#output\_vnet\_ids) | Virtual network names with there respective Ids |
<!-- END_TF_DOCS -->