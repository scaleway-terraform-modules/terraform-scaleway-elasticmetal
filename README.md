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
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.13 |
| <a name="requirement_scaleway"></a> [scaleway](#requirement\_scaleway) | >= 2.60.4 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_scaleway"></a> [scaleway](#provider\_scaleway) | >= 2.60.4 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [scaleway_baremetal_server.this](https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/resources/baremetal_server) | resource |
| [scaleway_domain_record.this](https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/resources/domain_record) | resource |
| [terraform_data.post_install](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |
| [scaleway_baremetal_offer.offer_ref](https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/data-sources/baremetal_offer) | data source |
| [scaleway_baremetal_option.private_network_option](https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/data-sources/baremetal_option) | data source |
| [scaleway_baremetal_os.os_version](https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/data-sources/baremetal_os) | data source |
| [scaleway_iam_ssh_key.instance_bootstrap](https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/data-sources/iam_ssh_key) | data source |
| [scaleway_secret.bootstrap_key](https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/data-sources/secret) | data source |
| [scaleway_secret.disk_encryption_key](https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/data-sources/secret) | data source |
| [scaleway_secret.disk_encryption_token](https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/data-sources/secret) | data source |
| [scaleway_secret_version.disk_encryption_key](https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/data-sources/secret_version) | data source |
| [scaleway_secret_version.disk_encryption_token](https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/data-sources/secret_version) | data source |
| [scaleway_secret_version.key_revision](https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/data-sources/secret_version) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_billing_period"></a> [billing\_period](#input\_billing\_period) | Billing period, either hourly or monthly | `string` | `"hourly"` | no |
| <a name="input_bootstrap_ssh_key_name"></a> [bootstrap\_ssh\_key\_name](#input\_bootstrap\_ssh\_key\_name) | Name of the IAM SSH key and Secret Manager secret used for bootstrap | `string` | n/a | yes |
| <a name="input_bootstrap_ssh_key_secret_path"></a> [bootstrap\_ssh\_key\_secret\_path](#input\_bootstrap\_ssh\_key\_secret\_path) | Path of the bootstrap SSH key secret in Scaleway Secret Manager (e.g. "/MY\_PROJECT/MY\_SERVER/SYSTEM\_KEY") | `string` | n/a | yes |
| <a name="input_create_timeout"></a> [create\_timeout](#input\_create\_timeout) | Timeout for creating the baremetal server | `string` | `"60m"` | no |
| <a name="input_disk_encryption_key_secret_name"></a> [disk\_encryption\_key\_secret\_name](#input\_disk\_encryption\_key\_secret\_name) | Name of the disk encryption key secret in Scaleway Secret Manager | `string` | `null` | no |
| <a name="input_disk_encryption_key_secret_path"></a> [disk\_encryption\_key\_secret\_path](#input\_disk\_encryption\_key\_secret\_path) | Path of the disk encryption key secret in Scaleway Secret Manager | `string` | `null` | no |
| <a name="input_disk_encryption_token_secret_name"></a> [disk\_encryption\_token\_secret\_name](#input\_disk\_encryption\_token\_secret\_name) | Name of the disk encryption token secret in Scaleway Secret Manager | `string` | `null` | no |
| <a name="input_disk_encryption_token_secret_path"></a> [disk\_encryption\_token\_secret\_path](#input\_disk\_encryption\_token\_secret\_path) | Path of the disk encryption token secret in Scaleway Secret Manager | `string` | `null` | no |
| <a name="input_dns_project_id"></a> [dns\_project\_id](#input\_dns\_project\_id) | Scaleway project ID where the DNS zones and records are managed | `string` | `null` | no |
| <a name="input_dns_zone"></a> [dns\_zone](#input\_dns\_zone) | DNS Zone to create record (optional - if not set, no DNS record will be created) | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Resource name | `string` | n/a | yes |
| <a name="input_offer"></a> [offer](#input\_offer) | Scaleway offer reference | `string` | `"EM-A116X-SSD"` | no |
| <a name="input_os"></a> [os](#input\_os) | OS to install | `map(string)` | <pre>{<br/>  "name": "Debian",<br/>  "version": "12 (Bookworm)"<br/>}</pre> | no |
| <a name="input_private_network_id"></a> [private\_network\_id](#input\_private\_network\_id) | Private network to attach the server to | `string` | `null` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Target Scaleway project ID | `string` | n/a | yes |
| <a name="input_ssh_key_ids"></a> [ssh\_key\_ids](#input\_ssh\_key\_ids) | List of additional SSH keys to install | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | List of tags to set on the resource | `list(string)` | n/a | yes |
| <a name="input_use_custom_partitioning"></a> [use\_custom\_partitioning](#input\_use\_custom\_partitioning) | Whether to use custom partitioning or not | `bool` | `false` | no |
| <a name="input_zone"></a> [zone](#input\_zone) | Zone to deploy the server to | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dns_fqdn"></a> [dns\_fqdn](#output\_dns\_fqdn) | Fully qualified domain name for the DNS record (if created) |
| <a name="output_id"></a> [id](#output\_id) | ID of the elasticmetal server |
| <a name="output_public_fqdn"></a> [public\_fqdn](#output\_public\_fqdn) | Public Fully qualified domain name generated by Scaleway |
| <a name="output_public_ips"></a> [public\_ips](#output\_public\_ips) | Public host addresses |
| <a name="output_server"></a> [server](#output\_server) | The scaleway\_baremetal\_server resource |
<!-- END_TF_DOCS -->

## Authors

Module is maintained with help from [the community](https://github.com/scaleway-terraform-modules/terraform-scaleway-elasticmetal/graphs/contributors).

## License

Mozilla Public License 2.0 Licensed. See [LICENSE](https://github.com/scaleway-terraform-modules/terraform-scaleway-elasticmetal/tree/master/LICENSE) for full details.