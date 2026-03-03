data "scaleway_baremetal_offer" "offer_ref" {
  zone                = var.zone
  name                = upper(var.offer)
  subscription_period = var.billing_period
}

data "scaleway_baremetal_os" "os_version" {
  zone    = var.zone
  name    = var.os["name"]
  version = var.os["version"]
}

data "scaleway_baremetal_option" "private_network_option" {
  count = var.private_network_id != null ? 1 : 0
  zone  = var.zone
  name  = "Private Network"
}

data "scaleway_iam_ssh_key" "instance_bootstrap" {
  name       = var.bootstrap_ssh_key_name
  project_id = var.project_id
}

# Secret bootstrap_key
data "scaleway_secret" "bootstrap_key" {
  name       = var.bootstrap_ssh_key_name
  path       = var.bootstrap_ssh_key_secret_path
  project_id = var.project_id
}

data "scaleway_secret_version" "key_revision" {
  secret_id  = data.scaleway_secret.bootstrap_key.id
  revision   = "latest"
  project_id = var.project_id
}

# Secret disk_encryption_key
data "scaleway_secret" "disk_encryption_key" {
  count      = var.use_custom_partitioning ? 1 : 0
  name       = var.disk_encryption_key_secret_name
  path       = var.disk_encryption_key_secret_path
  project_id = var.project_id
}

data "scaleway_secret_version" "disk_encryption_key" {
  count      = var.use_custom_partitioning ? 1 : 0
  secret_id  = data.scaleway_secret.disk_encryption_key[0].id
  revision   = "latest"
  project_id = var.project_id
}

# Secret disk_encryption_token
data "scaleway_secret" "disk_encryption_token" {
  count      = var.use_custom_partitioning ? 1 : 0
  name       = var.disk_encryption_token_secret_name
  path       = var.disk_encryption_token_secret_path
  project_id = var.project_id
}

data "scaleway_secret_version" "disk_encryption_token" {
  count      = var.use_custom_partitioning ? 1 : 0
  secret_id  = data.scaleway_secret.disk_encryption_token[0].id
  revision   = "latest"
  project_id = var.project_id
}