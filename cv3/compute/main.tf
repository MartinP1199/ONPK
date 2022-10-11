# --- compute/main.tf ---

# --- security groups ---
resource "openstack_networking_secgroup_v2" "secgroup_terrabuntu" {
  name        = "secgroup_terrabuntu"
  description = "My neutron security group"
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_rule_1" {
  description       = "allow SSH from uniza"
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = var.remote_ip_prefix
  security_group_id = "${openstack_networking_secgroup_v2.secgroup_terrabuntu.id}"
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_rule_2" {
  description       = "allow ping from uniza"
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  remote_ip_prefix  = var.remote_ip_prefix
  security_group_id = "${openstack_networking_secgroup_v2.secgroup_terrabuntu.id}"
}


# --- keys ---
resource "openstack_compute_keypair_v2" "keypair" {
  name = "terrakey"
}

resource "local_file" "private_key" {
  content = openstack_compute_keypair_v2.keypair.private_key
filename = "${path.module}/terrakey.pem"
}


# --- instances ---
resource "random_pet" "terrabuntu" {
  count = var.instances_count
  length = 1
}

resource "openstack_compute_instance_v2" "instance"{
  count           = var.instances_count
  name            = "terrabuntu-${random_pet.terrabuntu[count.index].id}"
  #name            = "test"
  image_id        = "0fc1152a-4037-4d89-a22a-60f477e2eba0"
  flavor_id       = "1eee6fc3-f274-4406-a054-1969ac79926f"
  key_pair        = "key-stud-15"
  
  #key_pair        = openstack_compute_keypair_v2.keypair.private_key     # tu je nejaka chyba, vyskakuje potom name error v instancii

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