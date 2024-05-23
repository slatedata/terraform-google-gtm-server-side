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
