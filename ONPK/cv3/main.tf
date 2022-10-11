# --- root/main.tf ---





# --- keys ---
resource "openstack_compute_keypair_v2" "keypair" {
name = "terrakey"
}

resource "local_file" "private_key" {
content = openstack_compute_keypair_v2.keypair.private_key
filename = "${path.module}/terrakey.pem"
}

module "instance" {
  source = "./compute"
  project = var.project
  enviroment = var.enviroment
  security_group_id = "${openstack_networking_secgroup_v2.secgroup_terrabuntu.id}"
  name = "stud15"
  script_file_path = var.script_file_path
  remote_ip_prefix = "158.193.0.0/16"
}


# --- instances ---
#key_pair = openstack_compute_keypair_v2.keypair.private_key

resource "random_pet" "server" {
  keepers = {
    # Generate a new pet name each time we switch to a new AMI id
    ami_id = var.ami_id
  }
}

resource "openstack_compute_instance_v2" "terrabuntu_01" {
  count = 2
  name            = "terrabuntu-${random_pet.server.id}"
  image_id        = "0fc1152a-4037-4d89-a22a-60f477e2eba0"
  flavor_id       = "1eee6fc3-f274-4406-a054-1969ac79926f"
  #key_pair        = "key-stud-15"
  key_pair     = openstack_compute_keypair_v2.keypair.private_key
  #security_groups = ["secgroup_terrabuntu"]
  security_groups = [ "${openstack_networking_secgroup_v2.secgroup_terrabuntu.id}" ]

  ami = random_pet.server.keepers.ami_id

  network {
    name = "ext-net"
  }

  network {
    name = "${openstack_networking_network_v2.tf_vbridge.name}"
  }

}