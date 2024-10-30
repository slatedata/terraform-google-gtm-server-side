variable "regions" {
  description = "The Google Cloud Regions that sGTM will be deployed in"
  type        = list(string)
  default     = ["europe-west1"]
}

variable "project_id" {
  description = "The Google Cloud Project ID that sGTM will be deployed in"
  type        = string
}

variable "deploy_preview_server" {
  description = "Whether to deploy an sGTM Preview Server"
  type        = bool
  default     = false
}

variable "preview_region" {
  description = "The region to deploy the sGTM Preview Server"
  type        = string
  default     = "europe-west1"
}

variable "min_preview_instance_count" {
  description = "The minimum number of sGTM Preview Servers to deploy"
  type        = number
  default     = 1
}

variable "max_preview_instance_count" {
  description = "The maximum number of sGTM Preview Servers to deploy"
  type        = number
  default     = 1
}

variable "deploy_load_balancer" {
  description = "Whether to deploy a load balancer in front of the sGTM instances"
  type        = bool
  default     = false
}

variable "max_instance_count" {
  description = "The maximum number of instances that each region can scale to"
  type        = number
  default     = 10
}

variable "min_instance_count" {
  description = "The minimum number of instances that each region can scale to"
  type        = number
  default     = 1
}

variable "container_config" {
  description = "The container configuration for your sGTM"
  type        = string
}

variable "deploy_ssl" {
  description = "Whether to deploy an SSL certificate for the sGTM instances. If you select this, you need to set the domain(s) in the domains variable."
  type        = bool
  default     = false
}

variable "domains" {
  description = "The domains to deploy the sGTM instances on. These are used to provision the certificates, so should end with a full stop e.g. `gtm.example.com.` "
  type        = list(string)
  default     = []
}

variable "deploy_ssl_policy" {
  description = "Whether to deploy an SSL policy for the sGTM instances"
  type        = bool
  default     = false
}

variable "ssl_policy_profile" {
  description = "The SSL policy profile for the sGTM instances"
  type        = string
  default     = "MODERN"
}

variable "min_tls_version" {
  description = "The minimum TLS version for the sGTM instances"
  type        = string
  default     = "TLS_1_2"
}

variable "cloud_armor_policy" {
  description = "The Cloud Armor policy to apply to the sGTM instances. This should be the self_link attribute for your policy."
  type        = string
  default     = null
}

variable "enable_logging" {
  description = "Whether to enable logging for the sGTM instances"
  type        = bool
  default     = false
}

variable "sample_rate" {
  description = "The rate at which to log requests"
  type        = number
  default     = 0.1
  validation {
    condition     = var.sample_rate >= 0 && var.sample_rate <= 1
    error_message = "sample_rate must be between 0 and 1"
  }
}

variable "deploy_cdn" {
  description = "Whether to deploy a CDN policy for the sGTM instances"
  type        = bool
  default     = false
}

variable "cdn_settings" {
  description = "The settings for the CDN policy"
  type = object({
    cache_mode  = string
    default_ttl = number
    client_ttl  = number
    max_ttl     = number
    cache_key_policy = object({
      include_host           = bool
      include_protocol       = bool
      include_query_string   = bool,
      whitelist_query_string = list(string),
      blacklist_query_string = list(string),
    })
  })
  default = {
    cache_mode  = "FORCE_CACHE_ALL"
    default_ttl = 3600
    client_ttl  = 3600
    max_ttl     = null
    cache_key_policy = {
      include_host           = true
      include_protocol       = true
      include_query_string   = true
      whitelist_query_string = []
      blacklist_query_string = []
    }
  }
}

variable "custom_response_headers" {
  description = "Custom response headers to add to the backend service"
  type        = list(string)
  default     = []
}
