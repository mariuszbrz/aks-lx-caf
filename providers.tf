terraform {
    required_providers {
      azurerm = {
        source  = "hashicorp/azurerm"
        version = "~>3.53.0"
      }
      azapi = {
        source = "azure/azapi"
        version = ">=1.0.0"
      }
      random = {
       source  = "hashicorp/random"
       version = "~>3.3.2"
      }
      kubernetes = {
        source  = "hashicorp/kubernetes"
        version = ">=2.19.0"
      }
      helm = {
        source  = "hashicorp/helm"
        version = ">=2.9.0"
      }
    }
    required_version = ">=1.3.9"
}

provider "azapi" {

}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}

provider "azurerm" {
  alias                      = "vhub"
  skip_provider_registration = true
  features {}
}

