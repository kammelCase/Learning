provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = true
    }
  }
}

terraform {

  cloud {
    
    organization = "mgbxxx"
    workspaces {
      project = "cloud-foundation"
      name = "cloud foundation"
      
    }
    token = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
    
  }
}