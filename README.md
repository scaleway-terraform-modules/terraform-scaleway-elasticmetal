# terraform-scaleway-elasticmetal

Terraform module to manage [Scaleway Elastic Metal](https://www.scaleway.com/en/elastic-metal/) (bare-metal) servers.

## Production status

This module is used in production. The default OS — **Debian 12 (Bookworm)** — has been validated in production environments and provides excellent support for the optional encryption-at-rest feature (`use_custom_partitioning = true`), including LUKS formatting of RAID arrays, automated key retrieval from Scaleway Secret Manager at boot, and systemd mount unit management.

## Features

- Deploy a bare-metal server with configurable offer and OS
- Bootstrap SSH key retrieved from Scaleway Secret Manager
- Optional custom disk partitioning with LUKS encryption at rest
- Optional private network (VPC) attachment via VLAN
- Optional DNS record creation

## Usage

### Minimal

```hcl
module "elasticmetal" {
  source  = "scaleway/elasticmetal/scaleway"
  version = ">= 1.0.0"

  name       = "my-server"
  project_id = var.project_id
  zone       = "fr-par-2"
  tags       = ["Env:Prod"]

  bootstrap_ssh_key_name        = "my-bootstrap-key"
  bootstrap_ssh_key_secret_path = "/MY_PROJECT/MY_SERVER/SYSTEM_KEY"
}
```

### With private network and DNS

```hcl
module "elasticmetal" {
  source  = "scaleway/elasticmetal/scaleway"
  version = ">= 1.0.0"

  name               = "my-server"
  project_id         = var.project_id
  zone               = "fr-par-2"
  tags               = ["Env:Prod"]
  private_network_id = scaleway_vpc_private_network.main.id

  bootstrap_ssh_key_name        = "my-bootstrap-key"
  bootstrap_ssh_key_secret_path = "/MY_PROJECT/MY_SERVER/SYSTEM_KEY"

  dns_zone       = "example.com"
  dns_project_id = var.dns_project_id
}
```

### With custom partitioning and disk encryption

```hcl
module "elasticmetal" {
  source  = "scaleway/elasticmetal/scaleway"
  version = ">= 1.0.0"

  name       = "my-server"
  project_id = var.project_id
  zone       = "fr-par-2"
  tags       = ["Env:Prod"]

  bootstrap_ssh_key_name        = "my-bootstrap-key"
  bootstrap_ssh_key_secret_path = "/MY_PROJECT/MY_SERVER/SYSTEM_KEY"

  use_custom_partitioning           = true
  disk_encryption_key_secret_name   = "disk-encryption-key"
  disk_encryption_key_secret_path   = "/MY_PROJECT/MY_SERVER/SYSTEM_KEY"
  disk_encryption_token_secret_name = "disk-encryption-token"
  disk_encryption_token_secret_path = "/MY_PROJECT/MY_SERVER/SYSTEM_TOKEN"
}
```

## Examples

- [Basic](./examples/basic) — minimal server without DNS or encryption

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->

## Authors

Module is maintained with help from [the community](https://github.com/scaleway-terraform-modules/terraform-scaleway-elasticmetal/graphs/contributors).

## License

Mozilla Public License 2.0 Licensed. See [LICENSE](https://github.com/scaleway-terraform-modules/terraform-scaleway-elasticmetal/tree/master/LICENSE) for full details.