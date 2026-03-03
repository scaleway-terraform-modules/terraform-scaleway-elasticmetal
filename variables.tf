variable "billing_period" {
  description = "Billing period, either hourly or monthly"
  type        = string
  default     = "hourly"
  validation {
    condition     = contains(["hourly", "monthly"], var.billing_period)
    error_message = "billing_period must be either \"hourly\" or \"monthly\""
  }
}

variable "bootstrap_ssh_key_name" {
  description = "Name of the IAM SSH key and Secret Manager secret used for bootstrap"
  type        = string
}

variable "bootstrap_ssh_key_secret_path" {
  description = "Path of the bootstrap SSH key secret in Scaleway Secret Manager (e.g. \"/MY_PROJECT/MY_SERVER/SYSTEM_KEY\")"
  type        = string
}

variable "create_timeout" {
  description = "Timeout for creating the baremetal server"
  type        = string
  default     = "60m"
}

variable "disk_encryption_key_secret_name" {
  description = "Name of the disk encryption key secret in Scaleway Secret Manager"
  type        = string
  default     = null
}

variable "disk_encryption_key_secret_path" {
  description = "Path of the disk encryption key secret in Scaleway Secret Manager"
  type        = string
  default     = null
}

variable "disk_encryption_token_secret_name" {
  description = "Name of the disk encryption token secret in Scaleway Secret Manager"
  type        = string
  default     = null
}

variable "disk_encryption_token_secret_path" {
  description = "Path of the disk encryption token secret in Scaleway Secret Manager"
  type        = string
  default     = null
}

variable "dns_project_id" {
  description = "Scaleway project ID where the DNS zones and records are managed"
  type        = string
  default     = null
  validation {
    condition     = var.dns_zone != null ? var.dns_project_id != null : true
    error_message = "dns_project_id must be set when dns_zone is provided"
  }
}

variable "dns_zone" {
  description = "DNS Zone to create record (optional - if not set, no DNS record will be created)"
  type        = string
  default     = null
}

variable "name" {
  description = "Resource name"
  type        = string
}

variable "offer" {
  description = "Scaleway offer reference"
  type        = string
  default     = "EM-A116X-SSD"
}

variable "os" {
  description = "OS to install"
  type        = map(string)
  default = {
    name    = "Debian",
    version = "12 (Bookworm)"
  }
}

variable "private_network_id" {
  description = "Private network to attach the server to"
  type        = string
  default     = null
}

variable "project_id" {
  description = "Target Scaleway project ID"
  type        = string
}

variable "ssh_key_ids" {
  description = "List of additional SSH keys to install"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "List of tags to set on the resource"
  type        = list(string)
}

variable "use_custom_partitioning" {
  description = "Whether to use custom partitioning or not"
  type        = bool
  default     = false
}

variable "zone" {
  description = "Zone to deploy the server to"
  type        = string
}