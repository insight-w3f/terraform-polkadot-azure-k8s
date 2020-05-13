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

resource "azurerm_resource_group" "k8s" {
  name     = "${var.cluster_name}-resources"
  location = data.azurerm_resource_group.this.location
}

resource "azurerm_route_table" "k8s" {
  name                = "${var.cluster_name}-routetable"
  location            = azurerm_resource_group.k8s.location
  resource_group_name = azurerm_resource_group.k8s.name

  route {
    name                   = "default"
    address_prefix         = "10.100.0.0/14"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.10.1.1"
  }
}

resource "azurerm_virtual_network" "k8s" {
  name                = "${var.cluster_name}-network"
  location            = azurerm_resource_group.k8s.location
  resource_group_name = azurerm_resource_group.k8s.name
  address_space       = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "k8s" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.k8s.name
  address_prefixes     = ["10.1.0.0/22"]
  virtual_network_name = azurerm_virtual_network.k8s.name
}

resource "azurerm_subnet_route_table_association" "example" {
  subnet_id      = azurerm_subnet.k8s.id
  route_table_id = azurerm_route_table.k8s.id
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

    vnet_subnet_id = azurerm_subnet.k8s.id
  }

  service_principal {
    client_id     = var.k8s_azure_service_principal_id
    client_secret = var.k8s_azure_service_principal_secret
  }

  network_profile {
    network_plugin = "azure"
  }

  tags = module.label.tags
}

data "azurerm_virtual_network" "public" {
  name                = var.vpc_id
  resource_group_name = var.azure_resource_group_name
}

resource "azurerm_virtual_network_peering" "public-k8s" {
  name                      = "public-k8s"
  remote_virtual_network_id = azurerm_virtual_network.k8s.id
  resource_group_name       = var.azure_resource_group_name
  virtual_network_name      = var.vpc_id
  allow_forwarded_traffic   = true
}

resource "azurerm_virtual_network_peering" "k8s-public" {
  name                      = "k8s-public"
  remote_virtual_network_id = data.azurerm_virtual_network.public.id
  resource_group_name       = azurerm_resource_group.k8s.name
  virtual_network_name      = azurerm_virtual_network.k8s.name
  allow_forwarded_traffic   = true
}