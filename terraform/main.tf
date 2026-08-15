terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.45"
    }
    teleport = {
      source  = "terraform.releases.teleport.dev/gravitational/teleport"
      version = "18.8.3"
    }
  }

  backend "s3" {
    bucket = "gbolmida-homelab-tfstate"
    key    = "terraform.tfstate"
    region = "us-west-002"

    endpoints = {
      s3 = "https://s3.us-west-002.backblazeb2.com"
    }

    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
    use_path_style              = true
    use_lockfile                = false
  }
}

variable "hcloud_token" {
  sensitive = true
}

variable "trusted_ssh_cidr" {
  sensitive = true
}

variable "teleport_join_method" {
  type    = string
  default = null
}

variable "teleport_join_token" {
  type    = string
  default = null
}

provider "hcloud" {
  token = var.hcloud_token
}

provider "teleport" {
  addr        = "bolmida.cloud:443"
  join_method = var.teleport_join_method
  join_token  = var.teleport_join_token
}


