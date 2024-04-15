output "external_ip" {
  value       = var.deploy_load_balancer ? join("", google_compute_global_address.default_ipv4[*].address) : null
  description = "The external IPV4 address of the load balancer"
}

output "external_ipv6_address" {
  value       = var.deploy_load_balancer ? join("", google_compute_global_address.default_ipv6[*].address) : null
  description = "The external IPV6 address of the load balancer"
}

output "cloud_run_names" {
  value       = { for region in var.regions : region => google_cloud_run_v2_service.gtmss-cr[region].name }
  description = "A map of the Cloud Run services names created by this module, keyed by region"
}

output "cloud_run_ids" {
  value       = { for region in var.regions : region => google_cloud_run_v2_service.gtmss-cr[region].id }
  description = "A map of the Cloud Run services names created by this module, keyed by region"
}

output "cloud_run_url_map" {
  value       = [for region in var.regions : google_cloud_run_v2_service.gtmss-cr[region].uri]
  description = "A list of the Cloud Run services URLs created by this module"
}

output "preview_url" {
  value       = var.deploy_preview_server ? join("", google_cloud_run_v2_service.gtmss-cr-preview[*].uri) : null
  description = "A list of the Cloud Run services URLs created by this module"
}
