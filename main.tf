terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = ">= 2.0.0"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}

variable "do_token" {
  type = string
}

variable "public_ssh_keys" {
  type = list(string)
}

variable "droplet_name" {
  type    = string
  default = "ubuntu-server"
}

variable "region" {
  type    = string
  default = "nyc3"
}

variable "size" {
  type    = string
  default = "s-1vcpu-1gb"
}

resource "digitalocean_droplet" "web" {
  name              = var.droplet_name
  region            = var.region
  size              = var.size
  image             = "ubuntu-24-04-x64"
  ssh_keys          = var.public_ssh_keys
  user_data         = file("cloud-init.yaml")
  backups           = false
  ipv6              = true
  monitoring        = true
  tags              = ["web"]
}

output "droplet_ip" {
  value = digitalocean_droplet.web.ipv4_address
}
