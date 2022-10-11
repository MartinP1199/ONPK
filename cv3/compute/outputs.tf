output "instance_ip_addr" {
  value = ["${openstack_compute_instance_v2.instance.*.name}"]
}
