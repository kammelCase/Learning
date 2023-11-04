Version v0.1.0
<!-- BEGIN_TF_DOCS -->
# Create One or more Linux Virtual Machine in Azure

This Module allows you to create and manage multiple Linux VirtualMachines in Microsoft Azure.

## Changelog

-   Version `v0.1.0`
    * Published artifact name: `linuxvm` 
    * Published artifact version: `0.1.0`
    * New module added.
    ---

## Includes

- [main.tf](./main.tf)
- [variables.tf](./variables.tf)
- [outputs.tf](./outputs.tf)
- [README.md](./README.md)
- [versions.tf](./versions.tf)
- [example/main.tf](./example/main.tf)
- [example/provider.tf](./example/provider.tf)
- [example/variables.tf](./example/variables.tf)
- [example/var-linuxvm.auto.tfvars](./example/var-linuxvm.auto.tfvars)
- [example/linuxvm-publish.yaml](./example/linuxvm-publish.yaml)

## Features

This module will:
- Create multiple Linux Virtual Machines in Microsoft Azure.
- Attach managed disks and mount them on Virtual machines.

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
| <a name="provider_random"></a> [random](#provider\_random) | `3.1.2` |
| <a name="provider_tls"></a> [tls](#provider\_tls) | `3.1.0` |

## Module Dependency

* Module "resourcegroup" ("./modules/iac-tf-module-az-resource-group")
* Module "virtualnetwork" ("./modules/iac-tf-module-az-virtual-network")
* Module "manageddisk" ("./modules/iac-tf-module-az-managed-disk")
* Module "keyvault" ("./modules/iac-tf-module-az-keyvault")
* Module "diskencryptionset" ("./modules/iac-tf-module-az-diskencryptionset")

## Security Controls

| CATEGORY          | SECURITY STANDARD        | SECURITY DEFINITION                                                                                       | REQUIRED?   |
| ----------------- | ------------------------ | --------------------------------------------------------------------------------------------------------- | ----------- |
| Access management | Access control           | Enable  vm has admin login,password , ssh key and disable password authentication                         | Required    |
| Security          | Versioning               | Update the window and linux agent if the current version is lower than the required version               | Recommended    |
| Data protection   | Encryption               | Ensure that windows vm  and linux vm has encryption setting along with host                               | Recommended    |
| Security          | License                  | Specifies the type of on-premise license                                                                  | Required    |
| Security          | Security Type            | Security type refers to the different security features available for a virtual machines.                 | Recommended    |
| Tags              | Tags                     | Ensure mandatory tags are provided as per client requirements                                             | Recommended |
| Security          | Networking               | Ensure network connectivity for your virtual machine by configuring network interface card (NIC) settings | Required    |
| Data protection   | secret                   | Both windows and linux vm has key vault ids and certificates for storing secrets                          | Required    |
| Security          | Termination notification | Termination protection prevents an instance  from accidental termination                                  | Recommended    |
| Data protection   | Secure boot enbled       | Specifies whether secure boot should be enabled on the virtual machine.                                   | Recommended    |

## Resources

| Name | Type |
|------|------|
| [azurerm_availability_set.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/availability_set) | resource |
| [azurerm_backup_protected_vm.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/backup_protected_vm) | resource |
| [azurerm_key_vault_access_policy.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_secret.password](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.ssh_key](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_linux_virtual_machine.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine) | resource |
| [azurerm_network_interface.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_network_interface_application_gateway_backend_address_pool_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_application_gateway_backend_address_pool_association) | resource |
| [azurerm_network_interface_application_security_group_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_application_security_group_association) | resource |
| [azurerm_network_interface_backend_address_pool_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_backend_address_pool_association) | resource |
| [azurerm_network_interface_nat_rule_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_nat_rule_association) | resource |
| [azurerm_network_interface_security_group_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_security_group_association) | resource |
| [azurerm_public_ip.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_virtual_machine_data_disk_attachment.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_data_disk_attachment) | resource |
| [azurerm_virtual_machine_extension.disk_init](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension) | resource |
| [random_integer.disk_init](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/integer) | resource |
| [random_password.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [tls_private_key.this](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [azurerm_application_gateway.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/application_gateway) | data source |
| [azurerm_application_security_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/application_security_group) | data source |
| [azurerm_availability_set.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/availability_set) | data source |
| [azurerm_backup_policy_vm.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/backup_policy_vm) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_disk_encryption_set.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/disk_encryption_set) | data source |
| [azurerm_key_vault.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_lb.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/lb) | data source |
| [azurerm_lb_backend_address_pool.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/lb_backend_address_pool) | data source |
| [azurerm_managed_disk.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/managed_disk) | data source |
| [azurerm_network_interface.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/network_interface) | data source |
| [azurerm_network_security_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/network_security_group) | data source |
| [azurerm_public_ip.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/public_ip) | data source |
| [azurerm_resource_group.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_storage_account.diagnostics_storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/storage_account) | data source |
| [azurerm_subnet.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |
| [azurerm_virtual_machine_scale_set.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_machine_scale_set) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_attach_managed_disks"></a> [attach\_managed\_disks](#input\_attach\_managed\_disks) | Manages data disks attachments | <pre>list(object({<br>    virtual_machine_name      = string # (Required) The Name of the Virtual Machine to which the Data Disk should be attached.<br>    managed_data_disk_name    = string # (Required) The Name of an existing Managed Disk which should be attached.<br>    managed_data_disk_rg_name = string # (Optional) Managed Disk's resource group name. Defaults to VM's resource group<br>    lun                       = number # (Required) The Logical Unit Number of the Data Disk, which needs to be unique within the Virtual Machine.<br>    caching                   = string # (Optional) Specifies the caching requirements for this Data Disk. Possible values include None, ReadOnly and ReadWrite. Default is None.<br>    write_accelerator_enabled = bool   # (Optional) Specifies if Write Accelerator is enabled on the disk. This can only be enabled on Premium_LRS managed disks with no caching and M-Series VMs. Defaults to false.<br>  }))</pre> | `[]` | no |
| <a name="input_availability_sets"></a> [availability\_sets](#input\_availability\_sets) | Manages an Availability Set for Virtual Machines. | <pre>list(object({<br>    name                         = string # (Required) Specifies the name of the availability set. Changing this forces a new resource to be created.<br>    resource_group_name          = string # (Required) Resource group name in which availability set is to be provisioned<br>    platform_fault_domain_count  = number # (Optional) Specifies the number of fault domains that are used. Defaults to 3. Changing this forces a new resource to be created.<br>    platform_update_domain_count = number # (Optional) Specifies the number of update domains that are used. Defaults to 5. Changing this forces a new resource to be created.<br>    proximity_placement_group_id = string # (Optional) The ID of the Proximity Placement Group to which this Virtual Machine should be assigned. Changing this forces a new resource to be created.<br>    managed                      = bool   # (Optional) Specifies whether the availability set is managed or not. Possible values are true (to specify aligned) or false (to specify classic). Default is true.<br>    additional_tags              = map(string) # (Optional) Additional Tags if required<br>  }))</pre> | `[]` | no |
| <a name="input_disk_init"></a> [disk\_init](#input\_disk\_init) | Format and mount all the additional disks attached to the virtual machine. | <pre>list(object({<br>    virtual_machine_name = string            # (Required) Name of the virtual machine<br>    re_run_disk_init     = bool              # (Optional) Should disk init be rerun?<br>    partitions = list(object({               # (Required) Create partitons from the attached disk<br>      lun    = number                        # (Required) From which disk should partition be made.<br>      size   = string                        # (Required) Size of the partition. For example: "4GB", "20GB" ..<br>      mount  = string                        # (Required) Where should this partition be mounted.<br>    }))<br>  }))</pre> | `[]` | no |
| <a name="input_linux_vms"></a> [linux\_vms](#input\_linux\_vms) | Manages Linux Virtual Machines. | <pre>list(object({<br>    name                              = string       # (Required) The name of the Linux Virtual Machine. Changing this forces a new resource to be created.<br>    location                          = string       # (Optional) Location in which virtual machine is to be deployed. Defaults to resource group's location<br>resource_group_name               = string       # (Required) Resource group name in which availability set is to be provisioned<br>    computer_name                     = string       # (Optional) Specifies the Hostname which should be used for this Virtual Machine. If unspecified this defaults to the value for the name field.<br>    admin_username                    = string       # (Required) The username of the local administrator used for the Virtual Machine. Changing this forces a new resource to be created.<br>    key_vault_name                    = string       # (Required) Existing key vault name to store vm secrets.<br>    admin_username_secret_name        = string       # (Required) New key vault secret name to store admin username.<br>    admin_password_secret_name        = string       # (Required) New key vault secret name to store admin password.<br>    ssh_private_key_secret_name       = string       # (Required) New key vault secret name to store private ssh key.<br>    secret_not_before_date            = string       # (Optional) Date and time in after which this secret can be activated or used. Default's to current timestamp.<br>    secret_expiration_date            = string       # (Optional) Date and time on which this secrets expire. Defaults to one year after current timestamp.<br>    size                              = string       # (Required) The SKU which should be used for this Virtual Machine, such as Standard_F2.<br>    disable_password_authentication   = bool         # (Optional) Should Password Authentication be disabled on this Virtual Machine? Defaults to true<br>    network_interface_names           = list(string) # (Required). A list of Network Interface names which should be attached to this Virtual Machine. The first Network Interface ID in this list will be the Primary Network Interface on the Virtual Machine.<br>    custom_data                       = string       # (Optional) The Custom Data script which should be used for this Virtual Machine. Changing this forces a new resource to be created.<br>    custom_data_args                  = map(string)  # (Optional) The Custom Data script args<br>    user_data                         = string       # (Optional) The Base64-Encoded User Data which should be used for this Virtual Machine.<br>    source_image_id                   = string       # (Optional) The ID of the Image which this Virtual Machine should be created from. Changing this forces a new resource to be created.<br>    source_image_offer                = string       # (Optional) Specifies the publisher of the image used to create the virtual machines.<br>    source_image_publisher            = string       # (Optional) Specifies the offer of the image used to create the virtual machines.<br>    source_image_sku                  = string       # (Optional) Specifies the SKU of the image used to create the virtual machines.<br>    source_image_version              = string       # (Optional) Specifies the version of the image used to create the virtual machines.<br>    os_disk_name                      = string       # (Optional) The name which should be used for the Internal OS Disk. Changing this forces a new resource to be created.<br>    os_disk_caching                   = string       # (Optional) The Type of Caching which should be used for the Internal OS Disk. Possible values are None, ReadOnly and ReadWrite. Default is None<br>    os_disk_storage_account_type      = string       # (Required) The Type of Storage Account which should back this the Internal OS Disk. Possible values are Standard_LRS, StandardSSD_LRS, Premium_LRS, StandardSSD_ZRS and Premium_ZRS. Changing this forces a new resource to be created.<br>    os_disk_encryption_set_name       = string       # (Optional) The ID of the Disk Encryption Set which should be used to Encrypt this OS Disk.<br>    os_disk_encryption_set_rg_name    = string       # (Optional) Disk encryption set's resource group name. Defaults to VM's resource group<br>    os_disk_size_gb                   = number       # (Optional) The Size of the Internal OS Disk in GB, if you wish to vary from the size used in the image this Virtual Machine is sourced from.<br>    os_disk_write_accelerator_enabled = bool         # (Optional) Should Write Accelerator be Enabled for this OS Disk? Defaults to false.<br>    availability_set_name             = string       # (Optional) Specifies the Name of the Availability Set in which the Virtual Machine should exist. Changing this forces a new resource to be created.<br>    availability_set_rg_name          = string       # (Optional) Availability set's resource group name. Defaults to VM's resource group<br>    zone                              = number       # (Optional) Specifies the Availability Zones in which this Linux Virtual Machine should be located.<br>    virtual_machine_scale_set_name    = string       # (Optional) Specifies the Orchestrated Virtual Machine Scale Set that this Virtual Machine should be created within.<br>    vm_scale_set_rg_name              = string       # (Optional) VM scale set's resource group name. Defaults to VM's resource group<br>    boot_diagnostics_sa_name          = string       # (Optional) The Azure Storage Account which should be used to store Boot Diagnostics<br>    diagnostics_sa_rg_name            = string       # (Optional) Diagnostic storage account's resource group name. Defaults to VM's resource group<br>    identity_type                     = string       # (Required) Specifies the type of Managed Service Identity that should be configured on this Linux Virtual Machine. Possible values are SystemAssigned, UserAssigned, SystemAssigned, UserAssigned (to enable both).<br>    identity_ids                      = list(string) # (Optional) Specifies a list of User Assigned Managed Identity IDs to be assigned to this Linux Virtual Machine.<br>    app_gateway_name                  = string       # (Optional) Application gateway name<br>    app_gateway_rg_name               = string       # (Optional) Application gateway's resource group name. Defaults to VM's resource group<br>    app_gateway_backend_pool_name     = string       # (Optional) Application gateway pool name<br>    application_security_group_name   = string       # (Optional) Application security group name<br>    network_security_group_name       = string       # (Optional) Network security group name<br>    load_balancer_name                = string       # (Optional) Load Balancer name<br>    load_balancer_rg_name             = string       # (Optional) Load balancer's resource group name. Defaults to VM's resource group<br>    load_balancer_backend_pool_name   = string       # (Optional) Load balancer backend pool name<br>    load_balancer_nat_rule_name       = string       # (Optional) Load balancer nat rule name<br>    recovery_service_vault_name       = string       # (Optional) Recovery service vault name<br>    recovery_service_vault_rg_name    = string       # (Optional) Recovery services vault's resource group name. Defaults to VM's resource group<br>    backup_policy_name                = string       # (Optional) Backup policy name<br>    additional_tags                   = map(string)  # (Optional) Additional Tags if required<br>  }))</pre> | `[]` | no |
| <a name="input_network_interfaces"></a> [network\_interfaces](#input\_network\_interfaces) | Manages Network Interfaces. | <pre>list(object({<br>    name                          = string       # (Required) The name of the Network Interface. Changing this forces a new resource to be created.<br>    dns_servers                   = list(string) # (Optional) List of Zero or more IP Addresses defining the DNS Servers which should be used for this Network Interface.<br>    enable_ip_forwarding          = bool         # (Optional) Should IP Forwarding be enabled? Defaults to false.<br>    enable_accelerated_networking = bool         # (Optional) Should Accelerated Networking be enabled? Defaults to false.<br>    internal_dns_name_label       = string       # (Optional) The (relative) DNS Name used for internal communications between Virtual Machines in the same Virtual Network.<br>    ip_configurations = list(object({<br>      name                          = string # (Required) A name used for this IP Configuration.<br>      private_ip_address_allocation = string # (Optional) The allocation method used for the Private IP Address. Possible values are Dynamic and Static. Default is Dynamic.<br>      vnet_name                     = string # (Optional) Vnet name<br>      vnet_resource_group_name     = string # (Required) Name of the resource group in which vnet exists.<br>      subnet_name                   = string # (Optional) The Name of the Subnet where this Network Interface should be located in. This is required when private_ip_address_version is set to IPv4.<br>      private_ip_address_version    = string # (Optional) The IP Version to use. Possible values are IPv4 or IPv6. Defaults to IPv4.<br>      public_ip_name                = string # (Optional) Reference to a Public IP Address to associate with this NIC, you can user managed public_ip address name also here.<br>      public_ip_rg_name             = string # (Optional) Resource group in which public ip exists. Default's to VMs resource group<br>      private_ip_address            = string # (Optional) The Static IP Address which should be used.<br>    }))<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_availability_sets"></a> [availability\_sets](#output\_availability\_sets) | Availability set names and there properties |
| <a name="output_linux_vm_ids"></a> [linux\_vm\_ids](#output\_linux\_vm\_ids) | Linux Virtual Machine names with there respective IDs |
| <a name="output_managed_disk_attachment"></a> [managed\_disk\_attachment](#output\_managed\_disk\_attachment) | Managed Disk names and with there respective properties |
| <a name="output_network_interfaces"></a> [network\_interfaces](#output\_network\_interfaces) | Network interface card names and there properties |

<!-- END_TF_DOCS -->