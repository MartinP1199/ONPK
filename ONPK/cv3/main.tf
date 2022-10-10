# --- root/main.tf ---

resource "openstack_networking_secgroup_v2" "secgroup_terrabuntu" {
  name        = "secgroup_terrabuntu"
  description = "My neutron security group"
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_rule_1" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "158.193.143.0/24"
  security_group_id = "${openstack_networking_secgroup_v2.secgroup_terrabuntu.id}"
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_rule_2" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  remote_ip_prefix  = "158.193.143.0/24"
  security_group_id = "${openstack_networking_secgroup_v2.secgroup_terrabuntu.id}"
}

resource "openstack_compute_instance_v2" "basic" {
  name            = "terrabuntu"
  image_id        = "0fc1152a-4037-4d89-a22a-60f477e2eba0"
  flavor_id       = "1eee6fc3-f274-4406-a054-1969ac79926f"
  key_pair        = "key-stud-15"
  #security_groups = ["secgroup_terrabuntu"]
  security_groups = [ "${openstack_networking_secgroup_v2.secgroup_terrabuntu.id}" ]

  network {
    name = "ext-net"
  }
}