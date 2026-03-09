terraform {
  # backend "azurerm" {
  #   resource_group_name  = "rg-tf-state"
  #   storage_account_name = "tfstate123456"
  #   container_name       = "tfstate"
  #   key                  = "dev.terraform.tfstate"
  # }
  backend "azurerm" {
    resource_group_name  = "rg-safranysAI-Dev"
    storage_account_name = "terraformstate240775"
    container_name       = "tfstatedev"
    key                  = "dev.terraform.tfstate"
  }
}
