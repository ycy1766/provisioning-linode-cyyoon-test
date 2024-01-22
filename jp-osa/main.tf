terraform {
  backend "s3" {
    bucket = "cloud-service-terraform-bucket"
    key                         = "terraform/cloudservice-image-build/cloudservice-image-build.terraform.tfstate"
    endpoints                   = { s3 = "https://jp-osa-1.linodeobjects.com" }
    region                      = "jp-osa-1"
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_region_validation      = true
    skip_metadata_api_check     = true
    skip_s3_checksum            = true
  }
}

module "virtualserver" {
  source                              = "../modules/virtualserver"
  linode_token                        = var.linode_token
  linode_instance_image               = var.linode_instance_image
  linode_instance_type                = var.linode_instance_type
  linode_instance_tags                = var.linode_instance_tags
  linode_instance_root_pass           = var.linode_instance_root_pass
  linode_instance_label               = var.linode_instance_hostname
  linode_instance_region              = var.linode_instance_region
  linode_virtualserver_firewall_label = var.linode_virtualserver_firewall_label
  linode_build_image_label            = var.linode_build_image_label
  linode_security_script_label        = var.linode_security_script_label    
  linode_apm_script_label             = var.linode_apm_script_label
  linode_apm_sec_script_label         = var.linode_apm_sec_script_label
  build_image_type                    = var.build_image_type
}