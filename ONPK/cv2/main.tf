# --- root/main.tf ---

resource "openstack_networking_network_v2" "vbridge" {
  name           = join("", ["v", "bridge"])
  admin_state_up = "true"
}