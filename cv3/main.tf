# --- root/main.tf ---


module "instance" {
  source = "./compute"
  project = var.project
  enviroment = "sample"
  #security_group_id = "${openstack_networking_secgroup_v2.secgroup_terrabuntu.id}"
  name = "stud15"
  instances_count = 2
  script_file_path = "${path.module}/${var.script_file_path}" #tu je nieco zle
  remote_ip_prefix = "158.193.0.0/16"
}