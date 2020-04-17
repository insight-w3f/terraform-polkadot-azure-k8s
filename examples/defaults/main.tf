provider "azurerm" {
  version = "=2.0.0"
  features {}
}

variable "k8s_sp_id_from_env" {}
variable "k8s_sp_sec_from_env" {}

resource "azurerm_resource_group" "this" {
  location = "eastus"
  name     = "default-test"
}

module "network" {
  source                    = "github.com/insight-w3f/terraform-polkadot-azure-network.git?ref=master"
  azure_resource_group_name = azurerm_resource_group.this.name
}

module "defaults" {
  source                             = "../.."
  azure_resource_group_name          = azurerm_resource_group.this.name
  k8s_azure_service_principal_id     = var.k8s_sp_id_from_env
  k8s_azure_service_principal_secret = var.k8s_sp_sec_from_env
  vpc_id                             = module.network.vpc_id
}
