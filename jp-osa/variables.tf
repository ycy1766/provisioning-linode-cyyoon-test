variable "linode_token" {
  default = "***************"
}
variable "linode_instance_image" {
  default = "linode/rocky9"
}
variable "linode_instance_type" {
  default = "g6-nanode-1"
}
variable "linode_instance_tags" {
  default = "cloudservice_build_img"
}
variable "linode_instance_root_pass" {
  default = "PlesaeChangeM@"
}
variable "linode_instance_region" {
  default = "jp-osa"
}
variable "linode_virtualserver_firewall_label" {
  default = "cloudservice_build_fw"
}
variable "linode_security_script_label" {
  default = "cloudservice_security_sh"
}
variable "linode_apm_script_label" {
  default = "cloudservice_apm_sh"
}
variable "linode_apm_sec_script_label" {
  default = "cloudservice_apm_sec_sh"
}
variable "build_image_type" {
  description = "This variable specifies the type of build for the image. It varies depending on the format of the script."
    type = map(object({
    script_path : string
    extra_vars  : map(string)
  }))
  default = {
    none_sh = {
      script_path = "/stackscript/stackscript-default.sh.tpl"
      extra_vars  = {}
    }
    apm = {
      script_path = "/stackscript/stackscript-apm.sh.tpl"
      extra_vars  = {}
    }
    apm_sec = {
      script_path = "/stackscript/stackscript-apm-sec.sh.tpl"
      extra_vars = {}
    }
    sec = {
      script_path = "/stackscript/stackscript-sec.sh.tpl"
      extra_vars  = {}
    }
  }
}
# ## Local 테스트시 주석 해제 하여 사용 (Gitlab 에서는 gitlab-ci.yml 파일에 의하여 자동 생성 혹은 수동 변수 설정)
# variable "linode_instance_hostname" {
#   default = "CLOUDService"
# }
# # Local 테스트시 주석 해제 하여 사용 (Gitlab 에서는 gitlab-ci.yml 파일에 의하여 자동 생성 혹은 수동 변수 설정)
# variable "linode_build_image_label" {
#   default = "2024012212_CLOUDService"
# }



