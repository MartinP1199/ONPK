# --- compute/main.tf ---

# --- http to ip ---
data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

# --- security groups ---
resource "openstack_networking_secgroup_v2" "secgroup_terrabuntu" {
  name        = "secgroup_terrabuntu"
  description = "My neutron security group"
}

#resource "openstack_networking_secgroup_rule_v2" "secgroup_rule_1" {
#  description       = "allow SSH from uniza"
#  direction         = "ingress"
#  ethertype         = "IPv4"
#  protocol          = "tcp"
#  port_range_min    = 22
#  port_range_max    = 22
#  remote_ip_prefix  = var.remote_ip_prefix
#  security_group_id = "${openstack_networking_secgroup_v2.secgroup_terrabuntu.id}"
#}
#
#resource "openstack_networking_secgroup_rule_v2" "secgroup_rule_2" {
#  description       = "allow ping from uniza"
#  direction         = "ingress"
#  ethertype         = "IPv4"
#  protocol          = "icmp"
#  remote_ip_prefix  = var.remote_ip_prefix
#  security_group_id = "${openstack_networking_secgroup_v2.secgroup_terrabuntu.id}"
#}

resource "openstack_networking_secgroup_rule_v2" "allow_myip_ssh" {
  description       = "allow SSH from myip"
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "${chomp(data.http.myip.response_body)}/32"
  security_group_id = "${openstack_networking_secgroup_v2.secgroup_terrabuntu.id}"
}

resource "openstack_networking_secgroup_rule_v2" "allow_myip_icmp" {
  description       = "allow ping from myip"
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  remote_ip_prefix  = "${chomp(data.http.myip.response_body)}/32"
  security_group_id = "${openstack_networking_secgroup_v2.secgroup_terrabuntu.id}"
}

resource "openstack_networking_secgroup_rule_v2" "allow_public_http" {
  description       = "allow public http on 80"
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.secgroup_01.id}"
}

# --- keys ---
resource "openstack_compute_keypair_v2" "keypair" {
  name = "${var.project}-key"
}

resource "local_file" "private_key" {
  content = openstack_compute_keypair_v2.keypair.private_key
  #filename = "${path.module}/${var.project}-key.pem"
  filename = "${pathexpand("~/.ssh")}/${var.project}-key.pem"
#  filename = "${var.project}-key.pem"
  file_permission = "0600"
}

# --- instances ---
resource "random_pet" "terrabuntu" {
  count = var.instances_count
  length = 1
}

resource "openstack_compute_instance_v2" "instance"{
  count           = var.instances_count
  name            = "terrabuntu-${random_pet.terrabuntu[count.index].id}"
  image_id        = var.image_id
  flavor_id       = var.flavor_id
  #key_pair        = "key-stud-15"
  key_pair        = openstack_compute_keypair_v2.keypair.name  # tu je nejaka chyba, vyskakuje potom name error v instancii

  #security_groups = ["secgroup_terrabuntu"]
  security_groups = [ "${openstack_networking_secgroup_v2.secgroup_terrabuntu.id}" ]
  #security_groups = var.security_group_id

  user_data = "${file(var.script_file_path)}"

  network {
    name = "ext-net"
  }

  #network {
  #  name = "${openstack_networking_network_v2.tf_vbridge.name}"
  #}

}