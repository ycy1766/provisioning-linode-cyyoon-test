
resource "linode_firewall" "virtualserver_linode_firewall_default" {
  label = var.linode_virtualserver_firewall_label
  inbound {
    label    = "ssh"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "22"
    ipv4     = ["118.130.18.0/24"]
    ipv6     = ["::/0"]
  }
  inbound_policy  = "DROP"
  outbound_policy = "ACCEPT"
}

resource "linode_instance" "virtualserver_instance" {
  image     = var.linode_instance_image
  region    = var.linode_instance_region
  type      = var.linode_instance_type
  label     = var.linode_instance_label
  tags      = [var.linode_instance_tags]
  root_pass = var.linode_instance_root_pass
}

resource "linode_firewall_device" "virtualserver_linode_firewall_device" {
  firewall_id = linode_firewall.virtualserver_linode_firewall_default.id
  entity_id   = linode_instance.virtualserver_instance.id
  depends_on = [
    linode_instance.virtualserver_instance, linode_firewall.virtualserver_linode_firewall_default
  ]
}

## Image  생성 하기전, Script 실행 시 일정 Wait 시간을 추가 하여, 스크립트 동작 시간을 추가 한다.
## 추후, 별도의 Validation 설정 예정
resource "null_resource" "previous" {}
resource "time_sleep" "wait_for_image_bake" {
  depends_on = [null_resource.previous,linode_instance.virtualserver_instance, linode_firewall.virtualserver_linode_firewall_default, linode_instance.virtualserver_instance]
  create_duration = "60s"
}

resource "linode_image" "virtualserver_instance_to_image" {
  label       = "${var.linode_instance_tags} sda image"
  description = "Image taken from instance(${var.linode_instance_tags})"
  disk_id     = linode_instance.virtualserver_instance.disk.0.id
  linode_id   = linode_instance.virtualserver_instance.id
  depends_on = [
    time_sleep.wait_for_image_bake
  ]
}

