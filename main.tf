module "label" {
  source = "github.com/robc-io/terraform-null-label.git?ref=0.16.1"
  tags = {
    NetworkName = var.network_name
    Owner       = var.owner
    Terraform   = true
    VpcType     = "main"
  }

  environment = var.environment
  namespace   = var.namespace
  stage       = var.stage
}

data "azurerm_resource_group" "this" {
  name = var.azure_resource_group_name
}

resource "azurerm_kubernetes_cluster" "this" {
  name                = var.cluster_name
  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name
  dns_prefix          = "cluster"
  kubernetes_version  = var.k8s_version

  default_node_pool {
    name    = "defaultwks"
    vm_size = var.worker_instance_type

    enable_auto_scaling = var.cluster_autoscale
    node_count          = var.cluster_autoscale ? null : var.num_workers
    min_count           = var.cluster_autoscale ? var.cluster_autoscale_min_workers : null
    max_count           = var.cluster_autoscale ? var.cluster_autoscale_max_workers : null

  }

  service_principal {
    client_id     = var.k8s_azure_service_principal_id
    client_secret = var.k8s_azure_service_principal_secret
  }

  tags = module.label.tags
}