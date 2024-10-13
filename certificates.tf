resource "google_certificate_manager_certificate" "sgtm_ssl_cert" {
  for_each = (var.deploy_load_balancer && var.deploy_ssl ? toset(var.domains) : [])
  name     = "sgtm-ssl-cert-${replace(each.key, ".", "-")}"
  managed {
    domains = [each.key]
  }
}

resource "random_id" "tf_prefix" {
  byte_length = 8
}

resource "google_certificate_manager_certificate_map" "sgtm_certmap" {
  count       = var.deploy_load_balancer && var.deploy_ssl ? 1 : 0
  depends_on  = [google_project_service.certificate-manager-api]
  name        = "sgtm-certmap-${random_id.tf_prefix.hex}"
  description = "Server Side GTM certificate map"
}

resource "google_certificate_manager_certificate_map_entry" "certmap_entries" {
  for_each     = (var.deploy_load_balancer && var.deploy_ssl ? toset(var.domains) : [])
  name         = "sgtm-entry-${replace(each.key, ".", "-")}"
  description  = "Certificate map entry for ${each.key}"
  map          = google_certificate_manager_certificate_map.sgtm_certmap.0.name
  certificates = [google_certificate_manager_certificate.sgtm_ssl_cert[each.key].id]
  hostname     = each.key
}
