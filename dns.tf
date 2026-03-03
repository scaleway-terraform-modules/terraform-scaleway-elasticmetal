resource "scaleway_domain_record" "this" {
  count = var.dns_zone != null ? 1 : 0

  project_id = var.dns_project_id
  dns_zone   = var.dns_zone
  name       = local.server_name
  type       = "A"
  data       = scaleway_baremetal_server.this.ipv4[0].address
  ttl        = 3600
}