#!/bin/bash


set -ex

if [ "$#" -lt 1 ]
then
    echo "you must pass the vlan id as parameter !"
    exit 1
fi

vlan_id="$1"
shift

if ! [[ "$vlan_id" =~ [0-9]+ ]]
then
    echo "vlan_id must be all numbers"
    exit 1
fi

get_physical_interface_name() {
    if [ -e "/etc/netplan/50-cloud-init.yaml" ]
    then
        interface_name=$(yq -r '.network.ethernets | keys | join(",") ' /etc/netplan/50-cloud-init.yaml)
    fi

    echo "$interface_name"
}

interface=$(get_physical_interface_name)
cat <<- EOF > /etc/netplan/99-vpc.yaml
network:
  version: 2
  vlans:
    $interface.$vlan_id:
      id: $vlan_id
      link: $interface
      dhcp4: true
      dhcp6: false
      dhcp4-overrides:
          use-routes: false
      nameservers:
        addresses: [169.254.169.254]
EOF
