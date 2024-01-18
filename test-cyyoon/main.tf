terraform {
    backend "s3" {                                                 
      bucket         = "tst"
      # key            = "VPS_HOSTNAME/VPS_HOSTNAME.terraform.tfstate" 
      #Sample
      key            = "sjhan-test-odin-006/sjhan-test-odin-006.terraform.tfstate" 
      endpoints      = { s3="https://kr.cafe24obs.com" }
      region         = "kr1"
      skip_credentials_validation = true
      skip_requesting_account_id  = true
      skip_region_validation      = true
      skip_metadata_api_check     = true
      skip_s3_checksum            = true
  }
}

module virtualserver {
	source = "../modules/virtualserver"
  firewall_label = "cyyoon-fw-label-12"
  linode_token = var.linode_token
  linode_instance_image = var.linode_instance_image
  linode_instance_type = var.linode_instance_type
  linode_instance_tags = var.linode_instance_tags 
  linode_instance_root_pass = var.linode_instance_root_pass
  linode_instance_label = var.linode_instance_hostaneme
  linode_instance_region = var.linode_instance_region
  linode_stackscript_id = var.linode_stackscript_id
  linode_virtualserver_firewall_label = var.linode_virtualserver_firewall_label
}