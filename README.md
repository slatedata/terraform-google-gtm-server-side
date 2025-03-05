# Google Tag Manager Server Side Terraform Module

Cloud Run based Google Tag Manager Server Side (GTMSS) with optional Load Balancer and multi-region deployment.

## Usage

```hcl
module "gtmss" {
  source  = "slatedata/gtm-server-side/google"
  version = "~> 0.1.0"

  project_id           = "my-project"
  regions              = ["us-central1", "us-east1"]
  container_config     = "ABCDEF123456FEDCBA654321"
  min_instance_count   = 3
  max_instance_count   = 10
  deploy_load_balancer = true
  deploy_ssl           = true
  domains              = ["sgtm.example.com.", "sgtm.example.org."]
}
```
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 4.50, < 6 |
| <a name="requirement_google-beta"></a> [google-beta](#requirement\_google-beta) | >= 4.50, < 6 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 5.42.0 |
| <a name="provider_google-beta"></a> [google-beta](#provider\_google-beta) | 5.42.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.6.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google-beta_google_compute_global_address.default_ipv4](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_compute_global_address) | resource |
| [google-beta_google_compute_global_address.default_ipv6](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_compute_global_address) | resource |
| [google-beta_google_compute_target_https_proxy.l7_proxy](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_compute_target_https_proxy) | resource |
| [google_certificate_manager_certificate.sgtm_ssl_cert](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/certificate_manager_certificate) | resource |
| [google_certificate_manager_certificate_map.sgtm_certmap](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/certificate_manager_certificate_map) | resource |
| [google_certificate_manager_certificate_map_entry.certmap_entries](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/certificate_manager_certificate_map_entry) | resource |
| [google_cloud_run_service_iam_policy.noauth](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_service_iam_policy) | resource |
| [google_cloud_run_service_iam_policy.noauth_preview](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_service_iam_policy) | resource |
| [google_cloud_run_v2_service.gtmss-cr](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_v2_service) | resource |
| [google_cloud_run_v2_service.gtmss-cr-preview](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_v2_service) | resource |
| [google_compute_backend_service.gtmss_backend](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_backend_service) | resource |
| [google_compute_backend_service.gtmss_serving_backend](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_backend_service) | resource |
| [google_compute_global_forwarding_rule.fwd_ipv4](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_forwarding_rule) | resource |
| [google_compute_global_forwarding_rule.fwd_ipv4_https](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_forwarding_rule) | resource |
| [google_compute_global_forwarding_rule.fwd_ipv6](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_forwarding_rule) | resource |
| [google_compute_global_forwarding_rule.fwd_ipv6_https](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_forwarding_rule) | resource |
| [google_compute_region_network_endpoint_group.serverless-neg](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_network_endpoint_group) | resource |
| [google_compute_ssl_policy.sgtm-ssl-policy](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_ssl_policy) | resource |
| [google_compute_target_http_proxy.l7_proxy](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_target_http_proxy) | resource |
| [google_compute_url_map.gtmss_url_map](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_url_map) | resource |
| [google_project_service.certificate-manager-api](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [google_project_service.cloud_run_api](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [google_project_service.compute_api](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [random_id.tf_prefix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [google_iam_policy.noauth](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/iam_policy) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cdn_settings"></a> [cdn\_settings](#input\_cdn\_settings) | The settings for the CDN policy | <pre>object({<br/>    cache_mode  = string<br/>    default_ttl = number<br/>    client_ttl  = number<br/>    max_ttl     = number<br/>    cache_key_policy = object({<br/>      include_host           = bool<br/>      include_protocol       = bool<br/>      include_query_string   = bool,<br/>      whitelist_query_string = list(string),<br/>      blacklist_query_string = list(string),<br/>    })<br/>  })</pre> | <pre>{<br/>  "cache_key_policy": {<br/>    "blacklist_query_string": [],<br/>    "include_host": true,<br/>    "include_protocol": true,<br/>    "include_query_string": true,<br/>    "whitelist_query_string": []<br/>  },<br/>  "cache_mode": "FORCE_CACHE_ALL",<br/>  "client_ttl": 3600,<br/>  "default_ttl": 3600,<br/>  "max_ttl": null<br/>}</pre> | no |
| <a name="input_cloud_armor_policy"></a> [cloud\_armor\_policy](#input\_cloud\_armor\_policy) | The Cloud Armor policy to apply to the sGTM instances. This should be the self\_link attribute for your policy. | `string` | `null` | no |
| <a name="input_container_config"></a> [container\_config](#input\_container\_config) | The container configuration for your sGTM | `string` | n/a | yes |
| <a name="input_custom_request_headers"></a> [custom\_request\_headers](#input\_custom\_request\_headers) | Custom request headers to send to the backend service | `list(string)` | `[]` | no |
| <a name="input_custom_response_headers"></a> [custom\_response\_headers](#input\_custom\_response\_headers) | Custom response headers to add to the backend service | `list(string)` | `[]` | no |
| <a name="input_deploy_cdn"></a> [deploy\_cdn](#input\_deploy\_cdn) | Whether to deploy a CDN policy for the sGTM instances | `bool` | `false` | no |
| <a name="input_deploy_load_balancer"></a> [deploy\_load\_balancer](#input\_deploy\_load\_balancer) | Whether to deploy a load balancer in front of the sGTM instances | `bool` | `false` | no |
| <a name="input_deploy_preview_server"></a> [deploy\_preview\_server](#input\_deploy\_preview\_server) | Whether to deploy an sGTM Preview Server | `bool` | `false` | no |
| <a name="input_deploy_ssl"></a> [deploy\_ssl](#input\_deploy\_ssl) | Whether to deploy an SSL certificate for the sGTM instances. If you select this, you need to set the domain(s) in the domains variable. | `bool` | `false` | no |
| <a name="input_deploy_ssl_policy"></a> [deploy\_ssl\_policy](#input\_deploy\_ssl\_policy) | Whether to deploy an SSL policy for the sGTM instances | `bool` | `false` | no |
| <a name="input_domains"></a> [domains](#input\_domains) | The domains to deploy the sGTM instances on. These are used to provision the certificates, so should end with a full stop e.g. `gtm.example.com.` | `list(string)` | `[]` | no |
| <a name="input_enable_logging"></a> [enable\_logging](#input\_enable\_logging) | Whether to enable logging for the sGTM instances | `bool` | `false` | no |
| <a name="input_max_instance_count"></a> [max\_instance\_count](#input\_max\_instance\_count) | The maximum number of instances that each region can scale to | `number` | `10` | no |
| <a name="input_max_preview_instance_count"></a> [max\_preview\_instance\_count](#input\_max\_preview\_instance\_count) | The maximum number of sGTM Preview Servers to deploy | `number` | `1` | no |
| <a name="input_min_instance_count"></a> [min\_instance\_count](#input\_min\_instance\_count) | The minimum number of instances that each region can scale to | `number` | `1` | no |
| <a name="input_min_preview_instance_count"></a> [min\_preview\_instance\_count](#input\_min\_preview\_instance\_count) | The minimum number of sGTM Preview Servers to deploy | `number` | `1` | no |
| <a name="input_min_tls_version"></a> [min\_tls\_version](#input\_min\_tls\_version) | The minimum TLS version for the sGTM instances | `string` | `"TLS_1_2"` | no |
| <a name="input_preview_region"></a> [preview\_region](#input\_preview\_region) | The region to deploy the sGTM Preview Server | `string` | `"europe-west1"` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The Google Cloud Project ID that sGTM will be deployed in | `string` | n/a | yes |
| <a name="input_regions"></a> [regions](#input\_regions) | The Google Cloud Regions that sGTM will be deployed in | `list(string)` | <pre>[<br/>  "europe-west1"<br/>]</pre> | no |
| <a name="input_sample_rate"></a> [sample\_rate](#input\_sample\_rate) | The rate at which to log requests | `number` | `0.1` | no |
| <a name="input_ssl_policy_profile"></a> [ssl\_policy\_profile](#input\_ssl\_policy\_profile) | The SSL policy profile for the sGTM instances | `string` | `"MODERN"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloud_run_ids"></a> [cloud\_run\_ids](#output\_cloud\_run\_ids) | A map of the Cloud Run services names created by this module, keyed by region |
| <a name="output_cloud_run_names"></a> [cloud\_run\_names](#output\_cloud\_run\_names) | A map of the Cloud Run services names created by this module, keyed by region |
| <a name="output_cloud_run_url_map"></a> [cloud\_run\_url\_map](#output\_cloud\_run\_url\_map) | A list of the Cloud Run services URLs created by this module |
| <a name="output_external_ip"></a> [external\_ip](#output\_external\_ip) | The external IPV4 address of the load balancer |
| <a name="output_external_ipv6_address"></a> [external\_ipv6\_address](#output\_external\_ipv6\_address) | The external IPV6 address of the load balancer |
| <a name="output_preview_url"></a> [preview\_url](#output\_preview\_url) | A list of the Cloud Run services URLs created by this module |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
