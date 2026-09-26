terraform {
  required_version = ">= 1.7.0"

  backend "azurerm" {
    container_name = "tfstate"
    key            = "koalatech-oidc.tfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
}
