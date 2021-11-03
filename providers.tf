provider "aviatrix" {
  controller_ip = var.aviatrix_controller_ip
  username      = var.aviatrix_admin_account
  password      = var.aviatrix_admin_password
}

provider "azurerm" {
  features {}

  subscription_id = var.azure_subscription_id
  client_id = var.azure_appId
  client_secret = var.azure_password
  tenant_id = var.azure_tenant
}

provider "aws" {
  region = "eu-central-1"
  access_key = var.aws_access
  secret_key =  var.aws_secret
}
