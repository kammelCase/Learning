Version v0.1.0
<!-- BEGIN_TF_DOCS -->
## Create Azure Subnets
This module allows you to create one or multiple Azure Subnets.

## Changelog

-   Version `v0.1.0`
    * Published artifact name: `subnet` 
    * Published artifact version: `v0.1.0`
  
    ---

# Includes
* main.tf
* variables.tf
* output.tf
* README.md
* versions.tf
* example/main.tf
* example/provider.tf
* example/variables.tf
* example/subnet-publish.yaml
* example/var-subnet.auto.tfvars

## Features
Create one or multiple subnets in azure

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
| <a name="provider_azurerm"></a> [terraform](#provider\_azurerm) | `1.1.9` |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | `3.3.0` |

## Module Dependency
* Module "resourcegroup" ("./modules/iac-tf-module-az-resource-group")
* Module "virtualnetworks" ("./modules/iac-tf-module-az-virtual-networks")

## Security Controls

| CATEGORY          | SECURITY STANDARD                                                                                                                                                                            | SECURITY DEFINITION                                                   | REQUIRED?   |
| ----------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------- | ----------- |
| Access management | Network security group                                                                                                                                                                       | Allows you to associate network security groups to subnet             | Recommended    |
| Access management | service_delegation                                                                                                                                                                       | Allows you to designate a specific subnet for an Azure PaaS service of your choice that needs to be injected into your virtual network.             | Recommended    |
| security          | [Enforce private link endpoint network policies](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet#enforce_private_link_endpoint_network_policies) | Enable  network policies for the private link endpoint on the subnet. | Recommended    |
| security          | [Enforce private link service network policies](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet#enforce_private_link_service_network_policies)   | Enable  network policies for the private link service on the subnet.  | Recommended    |
| Tags              | Tags                                                                                                                                                                                         | Ensure mandatory tags are provided as per client requirements         | Recommended |

## Resources

| Name | Type |
|------|------|
| [azurerm_subnet.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_virtual_network.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_tags"></a> [additional\_tags](#input\_additional\_tags) | Tags to be added for subnet | `map(string)` | `null` | Optional |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | The virtal networks subnets with their properties. | <pre>map(object({<br>     subnet_name                     = string                    <br>    vnet_name                   = string                    <br>    resource_group_name                   = string                    <br>    address_prefixes            = list(string)              <br>    pe_enable                   = bool                       <br>    pes_enable                  = bool                      <br>    service_endpoints           = list(string)              <br>    service_endpoint_policy_ids = list(string)<br>    delegation                  = list(object({<br>      name                      = string                    <br>      service_delegation        = list(object({<br>        name                    = string                    <br>        actions                 = list(string)             <br>      }))<br>    }))<br>  }))</pre> | `{}` | Required |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Primary subscription ID | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_subnet_ids"></a> [subnet\_ids](#output\_subnet\_ids) | Map of subnet names and IDs |

<!-- END_TF_DOCS -->