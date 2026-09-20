terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
  backend "azurerm" {
    resource_group_name  = "rg-backend"
    storage_account_name = "aibasedtodo"
    container_name       = "tfstate"
    key                  = "dev-axion-microservice/terraform.tfstate"
    use_oidc             = true

  }
}

provider "azurerm" {
  features {}
}
