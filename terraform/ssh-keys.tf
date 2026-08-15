resource "hcloud_ssh_key" "nixos_key" {
  name       = "nixos_key"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJDPUf8UGl5jg797p4jqXBHSzfqjopfHt5zwiAkk+Mq9 gbolmida@geo-nix"
}