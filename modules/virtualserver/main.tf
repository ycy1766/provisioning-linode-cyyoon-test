terraform {
  required_providers {
    linode = {
      source = "linode/linode"
      version = "2.13.0"
    }
  }
}

provider "linode" {
  token = var.linode_token
}