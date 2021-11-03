terraform {
  required_providers {
    aviatrix = {
      source = "aviatrixsystems/aviatrix"
      version = ">= 2.20"
    }
    aws = {
      source = "hashicorp/aws"
    }
    azurerm = {
      source = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
  required_version = ">= 0.13"
}
