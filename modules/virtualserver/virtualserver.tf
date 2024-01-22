## apm_sec 타입의 경우 apm 과 security 스크립트를 모두 실행 해야 하기 때문에 Condition 을 추가 해서 Merge 된 스크립트가 실행 하게 한다.
resource "linode_stackscript" "linode_stackscript" {
  for_each    = var.build_image_type
  images      = ["any/all"]
  label       = "linode_image_build_script_${each.key}"
  description = "Installs a Package for ${each.key} Script "
  script = (
    each.key == "apm_sec" ? templatefile("${path.module}${each.value.script_path}",
      { default_sh = templatefile("${path.module}/stackscript/default.sh.tpl", { hostname_label = var.linode_instance_label }),
        apm_sh     = templatefile("${path.module}/stackscript/apm.sh.tpl", { hostname_label = var.linode_instance_label }),
        sec_sh = templatefile("${path.module}/stackscript/sec.sh.tpl", { hostname_label = var.linode_instance_label }) })
    : each.key == "apm" ? templatefile("${path.module}${each.value.script_path}",
      { default_sh = templatefile("${path.module}/stackscript/default.sh.tpl", { hostname_label = var.linode_instance_label }),
        apm_sh = templatefile("${path.module}/stackscript/apm.sh.tpl", { hostname_label = var.linode_instance_label }) })
    : each.key == "sec" ? templatefile("${path.module}${each.value.script_path}",
      { default_sh = templatefile("${path.module}/stackscript/default.sh.tpl", { hostname_label = var.linode_instance_label }),
        sec_sh = templatefile("${path.module}/stackscript/sec.sh.tpl", { hostname_label = var.linode_instance_label }) })
    : templatefile("${path.module}${each.value.script_path}",
    { default_sh = templatefile("${path.module}/stackscript/default.sh.tpl", { hostname_label = var.linode_instance_label }) })
  )
  rev_note = "CLOUDService team version"
}

resource "linode_firewall" "virtualserver_linode_fw" {
  for_each = var.build_image_type
  label    = "${var.linode_virtualserver_firewall_label}-${each.key}"
  inbound {
    label    = "ssh"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "22"
    ipv4     = ["118.130.18.0/24"]
    ipv6     = ["::/0"]
  }
  inbound_policy  = "DROP"
  outbound_policy = "DROP"
}

resource "linode_instance" "virtualserver_instance" {
  for_each       = var.build_image_type
  image          = var.linode_instance_image
  region         = var.linode_instance_region
  type           = var.linode_instance_type
  label          = "${var.linode_instance_label}_${each.key}"
  tags           = [var.linode_instance_tags]
  root_pass      = var.linode_instance_root_pass
  stackscript_id = linode_stackscript.linode_stackscript["${each.key}"].id
}

resource "linode_firewall_device" "virtualserver_linode_firewall_device" {
  for_each    = var.build_image_type
  firewall_id = linode_firewall.virtualserver_linode_fw["${each.key}"].id
  entity_id   = linode_instance.virtualserver_instance["${each.key}"].id
  depends_on = [
    linode_instance.virtualserver_instance, linode_firewall.virtualserver_linode_fw
  ]
}

## Image  생성 하기전, Script 실행 시 일정 Wait 시간을 추가 하여, 스크립트 동작 시간을 추가 한다.
## 추후, 별도의 Validation 설정 예정
resource "null_resource" "previous" {}
resource "time_sleep" "wait_for_image_bake" {
  depends_on = [null_resource.previous,
  linode_instance.virtualserver_instance, ]
  create_duration = "60s"
}

resource "linode_image" "virtualserver_instance_to_image" {
  for_each    = var.build_image_type
  label       = "${var.linode_build_image_label}_${each.key}"
  description = "Image taken from instance(${var.linode_instance_tags})"
  disk_id     = linode_instance.virtualserver_instance["${each.key}"].disk.0.id
  linode_id   = linode_instance.virtualserver_instance["${each.key}"].id
  depends_on = [
    time_sleep.wait_for_image_bake
  ]
}
