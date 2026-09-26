terraform {
  required_version = ">= 1.7.0"

  backend "azurerm" {
    container_name = "tfstate"
    key            = "koalatech.tfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

provider "azurerm" {
  features {}
}