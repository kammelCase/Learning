## NOTE: Read all given instructions before updating the values to get the resources created in first run.

linux_vms = [
  {
    name                          = "mgblinuxvm01"     #(Required) Name of the virtual machine
    resource_group_name           = "iac-lab-rg01"         #(Required) Name of the resource group in which this virtual machine is to be provisioned
    admin_username                = "azureuser"     #(Required) Name of the admin user
    key_vault_name                =  [""]       #(Required) Name of the key vault in which secrets like admin username, admin password, ssh-private-key is to be stored
    key_vault_resource_group_name = "poc-vijesh-tfstate"       #(Required) Name of the resource group in which key vault exists
    size                          = "Standard_D2s_v3"   #(Required) Virtual machine size or sku
    network_interface_names       = ["nic-1"]       #(Required) Names of network interface cards to be attached to VM
    os_disk_storage_account_type  = "Standard_LRS"  #(Optional) Storage account type for os disk
    source_image_offer            = "UbuntuServer"  #(Optional) Specifies the offer of the image used to create the virtual machines
    source_image_publisher        = "Canonical"     #(Optional) Specifies the publisher of the image used to create the virtual machines
    source_image_sku              = "16.04-LTS"     #(Optional) Specifies the SKU of the image used to create the virtual machines
    source_image_version          = "latest"        #(Optional) Specifies the version of the image used to create the virtual machines

  }
]

network_interfaces = [
  {
    name = "nic-1"
    ip_configurations = [
      {
        name           = "ip-config-1"       #(Required) Name of the IP configuration
        vnet_name      = "iac-lab-vnet1"      #(Required) The allocation method used for the Private IP Address. Possible values are Dynamic and Static
        subnet_name    = "iac-lab-snet1"            #(Optional) Name of the public IP
        vnet_resource_group_name = "iac-lab-rg01" #(Required) Namr fo the virtual network
        public_ip_name = null           #(Required) Name of the subnet
      }
    ]
  }
]

attach_managed_disks = [
  {
    virtual_machine_name   = "mgblinuxvm01"  #(Required) Name of the virtual machine in which the managed disk is to be attached
    managed_data_disk_name = "ansibletest_OsDisk_1_3cdae46b541643a3acdcc04ea5aa84ab"      #(Required) Name of the managed disk to attch
  }
]

disk_init = [
  {
    virtual_machine_name = "mgblinuxvm01"                  #(Required) Virtual machine name
    re_run_disk_init     = false                        #(Optional) Re Run
    partitions = [                                      #(Required) Partitions to be created from that managed disk
      {
        lun   = 0                                       #(Required) Unique disk number
        size  = "1GB"                                   #(Required) Size of the partition
        mount = "/disk-0-0"                             #(Required) Mount point
      }
    ]
  }
]