# --- network ---
resource "openstack_networking_network_v2" "tf_vbridge" {
  name           = "tf_test_network"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "subnet_1" {
  network_id = "${openstack_networking_network_v2.tf_vbridge.id}"
  cidr       = "192.168.200.0/24"
}

# --- http to ip ---
data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}