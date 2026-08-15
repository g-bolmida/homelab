resource "hcloud_primary_ip" "primary_ip" {
name          = "primary_ip"
location      = "fsn1"
type          = "ipv4"
auto_delete   = true
  labels = {
    "env" : "homelab"
  }
}

resource "hcloud_network" "private_network" {
  name     = "private_network"
  ip_range = "10.0.0.0/16"
  labels = {
    "env" : "homelab"
  }
}

resource "hcloud_network_subnet" "private_network_subnet" {
  type         = "cloud"
  network_id   = hcloud_network.private_network.id
  network_zone = "eu-central"
  ip_range     = "10.0.1.0/24"
}

resource "hcloud_firewall" "cheyenne_firewall" {
  name = "cheyenne-firewall"
  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "22"
    source_ips = [
      var.trusted_ssh_cidr,
    ]
  }
}

resource "hcloud_server" "cheyenne" {
  name        = "cheyenne"
  image       = "rocky-10"
  server_type = "cx23"
  location    = "fsn1"
  labels = {
    "env" : "homelab"
  }
  public_net {
    ipv4_enabled = true
    ipv4 = hcloud_primary_ip.primary_ip.id
    ipv6_enabled = false
  }
  network {
    subnet_id = hcloud_network_subnet.private_network_subnet.id
    ip        = "10.0.1.5"
    alias_ips = []
  }
  firewall_ids = [hcloud_firewall.cheyenne_firewall.id]
  ssh_keys = [ hcloud_ssh_key.nixos_key.id ]
}