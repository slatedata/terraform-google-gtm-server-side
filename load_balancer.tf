resource "google_project_service" "compute_api" {
  count   = var.deploy_load_balancer ? 1 : 0
  service = "compute.googleapis.com"

  timeouts {
    create = "30m"
    update = "40m"
  }
  disable_on_destroy = false
}

resource "google_project_service" "certificate-manager-api" {
  service = "certificatemanager.googleapis.com"

  timeouts {
    create = "30m"
    update = "40m"
  }
  disable_on_destroy = false
}

resource "google_compute_global_address" "default_ipv6" {
  depends_on = [google_project_service.compute_api]
  count      = var.deploy_load_balancer ? 1 : 0
  provider   = google-beta
  project    = var.project_id
  name       = "gtmss-ipv6-address"
  ip_version = "IPV6"
}

resource "google_compute_global_address" "default_ipv4" {
  depends_on = [google_project_service.compute_api]
  count      = var.deploy_load_balancer ? 1 : 0
  provider   = google-beta
  project    = var.project_id
  name       = "gtmss-ipv4-address"
  ip_version = "IPV4"
}


resource "google_compute_region_network_endpoint_group" "serverless-neg" {
  depends_on            = [google_project_service.compute_api]
  for_each              = toset([for region in var.regions : region if var.deploy_load_balancer])
  name                  = "gtmss-${each.key}"
  network_endpoint_type = "SERVERLESS"
  region                = each.key

  cloud_run {
    service = google_cloud_run_v2_service.gtmss-cr[each.key].name
  }
}


#
resource "google_compute_global_forwarding_rule" "fwd_ipv4" {
  count                 = var.deploy_load_balancer ? 1 : 0
  name                  = "ipv4-http-forwarding-rule"
  target                = google_compute_target_http_proxy.l7_proxy.0.id
  ip_address            = google_compute_global_address.default_ipv4.0.id
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "80"
  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_global_forwarding_rule" "fwd_ipv6" {
  count                 = var.deploy_load_balancer ? 1 : 0
  name                  = "ipv6-http-forwarding-rule"
  target                = google_compute_target_http_proxy.l7_proxy.0.id
  ip_address            = google_compute_global_address.default_ipv6.0.id
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "80"
  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_global_forwarding_rule" "fwd_ipv4_https" {
  count                 = var.deploy_load_balancer && var.deploy_ssl ? 1 : 0
  name                  = "ipv4-https-forwarding-rule"
  target                = google_compute_target_https_proxy.l7_proxy.0.id
  ip_address            = google_compute_global_address.default_ipv4.0.id
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "443"
  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_global_forwarding_rule" "fwd_ipv6_https" {
  count                 = var.deploy_load_balancer && var.deploy_ssl ? 1 : 0
  name                  = "ipv6-https-forwarding-rule"
  target                = google_compute_target_https_proxy.l7_proxy.0.id
  ip_address            = google_compute_global_address.default_ipv6.0.id
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "443"
  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_target_http_proxy" "l7_proxy" {
  count   = var.deploy_load_balancer ? 1 : 0
  name    = "l7-xlb-gtmss-proxy-http"
  url_map = google_compute_url_map.gtmss_url_map.0.id
}

resource "google_compute_target_https_proxy" "l7_proxy" {
  count           = var.deploy_load_balancer && var.deploy_ssl ? 1 : 0
  provider        = google-beta
  project         = var.project_id
  name            = "l7-xlb-gtmss-proxy-https"
  url_map         = google_compute_url_map.gtmss_url_map.0.id
  certificate_map = "//certificatemanager.googleapis.com/${google_certificate_manager_certificate_map.sgtm_certmap.0.id}"
  ssl_policy      = var.deploy_ssl_policy ? google_compute_ssl_policy.sgtm-ssl-policy.0.self_link : null
}

resource "google_compute_backend_service" "gtmss_backend" {
  depends_on              = [google_project_service.compute_api]
  count                   = var.deploy_load_balancer ? 1 : 0
  name                    = "gtmss-backend"
  protocol                = "HTTP"
  port_name               = "http"
  timeout_sec             = 30
  security_policy         = var.cloud_armor_policy
  enable_cdn              = var.deploy_cdn && length(var.custom_request_headers) == 0
  custom_response_headers = var.custom_response_headers
  dynamic "cdn_policy" {
    for_each = var.deploy_cdn && length(var.custom_request_headers) == 0 ? [1] : []
    content {
      cache_mode  = var.cdn_settings.cache_mode
      default_ttl = var.cdn_settings.default_ttl
      client_ttl  = var.cdn_settings.client_ttl
      max_ttl     = var.cdn_settings.max_ttl
      cache_key_policy {
        include_host         = var.cdn_settings.cache_key_policy.include_host
        include_protocol     = var.cdn_settings.cache_key_policy.include_protocol
        include_query_string = var.cdn_settings.cache_key_policy.include_query_string
      }
    }
  }
  log_config {
    enable      = var.enable_logging
    sample_rate = var.sample_rate
  }
  dynamic "backend" {
    for_each = toset(var.regions)
    content {
      group = google_compute_region_network_endpoint_group.serverless-neg[backend.key].id
    }
  }
  custom_request_headers = var.custom_request_headers
}


resource "google_compute_backend_service" "gtmss_serving_backend" {
  depends_on              = [google_project_service.compute_api]
  count                   = var.deploy_load_balancer && length(var.custom_request_headers) > 0 ? 1 : 0
  name                    = "gtmss-serving-backend"
  description             = "Backend to serve GTM and GTAG scripts, no custom headers applied"
  protocol                = "HTTP"
  port_name               = "http"
  timeout_sec             = 30
  security_policy         = var.cloud_armor_policy
  enable_cdn              = var.deploy_cdn
  custom_response_headers = var.custom_response_headers
  dynamic "cdn_policy" {
    for_each = var.deploy_cdn ? [1] : []
    content {
      cache_mode  = var.cdn_settings.cache_mode
      default_ttl = var.cdn_settings.default_ttl
      client_ttl  = var.cdn_settings.client_ttl
      max_ttl     = var.cdn_settings.max_ttl
      cache_key_policy {
        include_host         = var.cdn_settings.cache_key_policy.include_host
        include_protocol     = var.cdn_settings.cache_key_policy.include_protocol
        include_query_string = var.cdn_settings.cache_key_policy.include_query_string
      }
    }
  }
  log_config {
    enable      = var.enable_logging
    sample_rate = var.sample_rate
  }
  dynamic "backend" {
    for_each = toset(var.regions)
    content {
      group = google_compute_region_network_endpoint_group.serverless-neg[backend.key].id
    }
  }

}

resource "google_compute_url_map" "gtmss_url_map" {
  count           = var.deploy_load_balancer ? 1 : 0
  name            = "gtmss-url-map"
  default_service = google_compute_backend_service.gtmss_backend.0.id
  dynamic "host_rule" {
    for_each = length(var.custom_request_headers) > 0 ? [1] : []
    content {
      hosts        = var.domains
      path_matcher = "serving"
    }
  }
  dynamic "path_matcher" {
    for_each = length(var.custom_request_headers) > 0 ? [1] : []
    content {
      name = "serving"
      path_rule {
        paths   = ["/gtm.js", "/gtag/*"]
        service = google_compute_backend_service.gtmss_serving_backend.0.id
      }
      path_rule {
        paths   = ["/*"]
        service = google_compute_backend_service.gtmss_backend.0.id
      }
      default_service = google_compute_backend_service.gtmss_backend.0.id
    }
  }


}



resource "google_compute_ssl_policy" "sgtm-ssl-policy" {
  count           = var.deploy_ssl_policy ? 1 : 0
  name            = "sgtm-ssl-policy-${random_id.tf_prefix.hex}"
  profile         = var.ssl_policy_profile
  min_tls_version = var.min_tls_version
}
