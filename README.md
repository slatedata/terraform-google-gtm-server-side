# Google Tag Manager Server Side Terraform Module

Cloud Run based Google Tag Manager Server Side (GTMSS) with optional Load Balancer and multi-region deployment.

## Usage

```hcl
module "gtmss" {
  source  = "slatedata/terraform-google-gtm-server-side"
  version = "~> 0.1.0"

  project_id           = "my-project"
  regions              = ["us-central1", "us-east1"]
  container_config     = "ABCDEF123456FEDCBA654321"
  min_instance_count   = 3
  max_instance_count   = 10
  deploy_load_balancer = true
}
```
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| container\_config | The container configuration for your sGTM | `any` | n/a | yes |
| deploy\_load\_balancer | Whether to deploy a load balancer in front of the sGTM instances | `bool` | `false` | no |
| deploy\_preview\_server | Whether to deploy an sGTM Preview Server | `bool` | `false` | no |
| max\_instance\_count | The maximum number of instances that each region can scale to | `number` | `10` | no |
| max\_preview\_servers | The maximum number of sGTM Preview Servers to deploy | `number` | `1` | no |
| min\_instance\_count | The minimum number of instances that each region can scale to | `number` | `1` | no |
| min\_preview\_servers | The minimum number of sGTM Preview Servers to deploy | `number` | `1` | no |
| preview\_region | The region to deploy the sGTM Preview Server | `any` | n/a | yes |
| project\_id | The Google Cloud Project ID that sGTM will be deployed in | `string` | n/a | yes |
| regions | The Google Cloud Regions that sGTM will be deployed in | `list(string)` | <pre>[<br>  "europe-west1"<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| cloud\_run\_ids | A map of the Cloud Run services names created by this module, keyed by region |
| cloud\_run\_names | A map of the Cloud Run services names created by this module, keyed by region |
| cloud\_run\_url\_map | A list of the Cloud Run services URLs created by this module |
| external\_ip | The external IPV4 address of the load balancer |
| external\_ipv6\_address | The external IPV6 address of the load balancer |
| preview\_url | A list of the Cloud Run services URLs created by this module |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->