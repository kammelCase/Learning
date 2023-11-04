terraform {
  cloud {
    organization = "MassGeneralBrighamDigital"

    workspaces {
      name = "Azure-ICC-mgb-icc-cloud-foundations-e2-rg"
    }
  }

  required_providers {
    tfe = {
      version = "~> 0.49.2"
    }
    azurerm = {
      version = "~> 3.0.0"
    }
  }
}

provider "tfe" {
  hostname = "app.terraform.io"
  token    = var.team_token
}

variable "team_token" {
  type = string
  description = "tfe workspace variable"
}

variable "azure_subscription" {
  type = string
  description = "tfe workspace variable"
}

variable "azure_icc_tenant" {
  type = string
  description = "tfe workspace variable"

}

variable "azure_principal" {
  type = string
  description = "tfe workspace variable"

}

variable "azure_principal_secret" {
  type = string
  description = "tfe workspace variable"

}

provider "azurerm" {
  features {}
  subscription_id   = var.azure_subscription      
  tenant_id         = var.azure_icc_tenant        
  client_id         = var.azure_principal         
  client_secret     = var.azure_principal_secret  
}

