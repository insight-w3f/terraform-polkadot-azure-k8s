########
# Label
########
variable "environment" {
  description = "The environment"
  type        = string
  default     = ""
}

variable "namespace" {
  description = "The namespace to deploy into"
  type        = string
  default     = ""
}

variable "stage" {
  description = "The stage of the deployment"
  type        = string
  default     = ""
}

variable "network_name" {
  description = "The network name, ie kusama / mainnet"
  type        = string
  default     = ""
}

variable "owner" {
  description = "Owner of the infrastructure"
  type        = string
  default     = ""
}

########
# Azure
########

variable "azure_resource_group_name" {
  description = "Name of Azure Resource Group"
  type        = string
}

########
# K8S
########

variable "cluster_name" {
  description = "Name of the k8s cluster"
  type        = string
  default     = "cluster"
}

variable "k8s_version" {
  description = "Version of k8s to use - override to use a version other than `latest`"
  type        = string
  default     = null
}

variable "num_workers" {
  description = "Number of workers for worker pool"
  type        = number
  default     = 1
}

variable "worker_instance_type" {
  description = "Instance type for workers"
  type        = string
  default     = "Standard_D2_v2"
}

variable "cluster_autoscale" {
  description = "Do you want the cluster's worker pool to autoscale?"
  type        = bool
  default     = false
}

variable "cluster_autoscale_min_workers" {
  description = "Minimum number of workers in worker pool"
  type        = number
  default     = 1
}

variable "cluster_autoscale_max_workers" {
  description = "Maximum number of workers in worker pool"
  type        = number
  default     = 1
}

variable "k8s_azure_service_principal_id" {
  description = "ID for the service principal for the k8s cluster. This should NOT be the same as your deployment SP"
  type        = string
}

variable "k8s_azure_service_principal_secret" {
  description = "Secret for the service principal for the k8s cluster. This should NOT be the same as your deployment SP"
  type        = string
}
