resource "scaleway_baremetal_server" "this" {
  name     = var.dns_zone != null ? "${local.server_name}.${var.dns_zone}" : local.server_name
  hostname = var.dns_zone != null ? "${local.server_name}.${var.dns_zone}" : null
  zone     = var.zone

  project_id = var.project_id
  offer      = data.scaleway_baremetal_offer.offer_ref.offer_id

  ssh_key_ids = concat(
    [data.scaleway_iam_ssh_key.instance_bootstrap.id],
    var.ssh_key_ids
  )

  os = data.scaleway_baremetal_os.os_version.os_id
  partitioning = var.use_custom_partitioning ? (
    strcontains(lower(data.scaleway_baremetal_offer.offer_ref.name), "nvme") ? local.partition_scheme["nvme"] : local.partition_scheme["default"]
  ) : null

  dynamic "options" {
    for_each = var.private_network_id != null ? [1] : []
    content {
      id = data.scaleway_baremetal_option.private_network_option[0].id
    }
  }

  dynamic "private_network" {
    for_each = var.private_network_id != null ? [1] : []
    content {
      id = var.private_network_id
    }
  }

  tags = var.tags

  timeouts {
    create = var.create_timeout
  }
}

resource "terraform_data" "post_install" {
  triggers_replace = [
    scaleway_baremetal_server.this.id
  ]

  depends_on = [
    scaleway_baremetal_server.this
  ]

  connection {
    type        = "ssh"
    user        = "root"
    private_key = jsondecode(base64decode(data.scaleway_secret_version.key_revision.data)).ssh_private_key
    host        = scaleway_baremetal_server.this.ipv4[0].address
  }

  provisioner "file" {
    source      = "${path.module}/scripts"
    destination = "/tmp"
  }

  provisioner "file" {
    content = templatefile("${path.module}/templates/encrypt_disk.sh.tftpl", {
      secret_id    = var.use_custom_partitioning ? split("/", data.scaleway_secret_version.disk_encryption_key[0].secret_id)[1] : "",
      region       = substr(var.zone, 0, 6),
      access_token = var.use_custom_partitioning ? base64decode(data.scaleway_secret_version.disk_encryption_token[0].data) : ""
    })
    destination = "/tmp/encrypt_disk.sh"
  }

  provisioner "remote-exec" {
    inline = concat(
      [
        "cloud-init status --wait || true",
        "apt update",
        "apt-get install -q -y yq cloud-init",
        "chmod +x /tmp/scripts/*",
      ],
      var.use_custom_partitioning ? [
        "chmod 755 /tmp/encrypt_disk.sh",
        "/tmp/encrypt_disk.sh",
      ] : [],
      local.vlan_id != null ? ["/tmp/scripts/setup_private_network.sh ${local.vlan_id}"] : [],
      [
        "shutdown -r +1"
      ]
    )
  }
}