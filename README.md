# terraform-polkadot-azure-k8s-cluster

[![open-issues](https://img.shields.io/github/issues-raw/insight-w3f/terraform-polkadot-azure-k8s-cluster?style=for-the-badge)](https://github.com/insight-w3f/terraform-polkadot-azure-k8s-cluster/issues)
[![open-pr](https://img.shields.io/github/issues-pr-raw/insight-w3f/terraform-polkadot-azure-k8s-cluster?style=for-the-badge)](https://github.com/insight-w3f/terraform-polkadot-azure-k8s-cluster/pulls)
[![build-status](https://img.shields.io/circleci/build/gh/insight-w3f/terraform-polkadot-azure-k8s-cluster?style=for-the-badge)](https://circleci.com/gh/insight-w3f/terraform-polkadot-azure-k8s-cluster)

## Features

This module...

## Terraform Versions

For Terraform v0.12.0+

## Usage

```
module "this" {
    source = "github.com/insight-w3f/terraform-polkadot-azure-k8s-cluster"

}
```

To use with the Terraform Helm provider, you will need to specify the following:

```
provider "helm" {
  kubernetes {
    host                   = module.cluster.endpoint
    username               = module.cluster.username
    password               = module.cluster.password
    client_certificate     = base64decode(module.cluster.cluster_client_certificate)
    client_key             = base64decode(module.cluster.cluster_client_key)
    cluster_ca_certificate = base64decode(module.cluster.cluster_ca_cert)
    load_config_file       = false
  }
}
```
## Examples

- [defaults](https://github.com/insight-w3f/terraform-polkadot-azure-k8s-cluster/tree/master/examples/defaults)

## Known  Issues
No issue is creating limit on this module.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Providers

| Name | Version |
|------|---------|
| azurerm | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| azure\_resource\_group\_name | Name of Azure Resource Group | `string` | n/a | yes |
| cluster\_autoscale | Do you want the cluster's worker pool to autoscale? | `bool` | `false` | no |
| cluster\_autoscale\_max\_workers | Maximum number of workers in worker pool | `number` | `1` | no |
| cluster\_autoscale\_min\_workers | Minimum number of workers in worker pool | `number` | `1` | no |
| cluster\_name | Name of the k8s cluster | `string` | `"cluster"` | no |
| k8s\_azure\_service\_principal\_id | ID for the service principal for the k8s cluster. This should NOT be the same as your deployment SP | `string` | n/a | yes |
| k8s\_azure\_service\_principal\_secret | Secret for the service principal for the k8s cluster. This should NOT be the same as your deployment SP | `string` | n/a | yes |
| k8s\_version | Version of k8s to use - override to use a version other than `latest` | `string` | n/a | yes |
| num\_workers | Number of workers for worker pool | `number` | `1` | no |
| tags | Key value pair to tag all resources | `map(string)` | `{}` | no |
| vpc\_id | Name of the public VPC for the ASG nodes | `string` | `""` | no |
| worker\_instance\_type | Instance type for workers | `string` | `"Standard_D2_v2"` | no |

## Outputs

| Name | Description |
|------|-------------|
| cluster\_ca\_cert | The base64 encoded public certificate for the cluster's certificate authority |
| cluster\_client\_certificate | The base64 encoded public certificate used by clients to access the cluster |
| cluster\_client\_key | The base64 encoded private key used by clients to access the cluster |
| endpoint | The base URL of the API server on the Kubernetes master node |
| id | A unique ID that can be used to identify and reference a Kubernetes cluster |
| kube\_config | The full contents of the Kubernetes cluster's kubeconfig file |
| password | The cluster password |
| username | The cluster username |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Testing
This module has been packaged with terratest tests

To run them:

1. Install Go
2. Run `make test-init` from the root of this repo
3. Run `make test` again from root

## Authors

Module managed by [Richard Mah](https://github.com/shinyfoil)

## Credits

- [Anton Babenko](https://github.com/antonbabenko)

## License

Apache 2 Licensed. See LICENSE for full details.