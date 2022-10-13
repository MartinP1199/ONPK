output "instance_name" {
  value = ["${openstack_compute_instance_v2.instance.*.name}"]
  description = "Names of compute instances."
}

output "instance_ip_addr" {
  value = ["${openstack_compute_instance_v2.instance.*.network.0.fixed_ip_v4}"]
  description = "public IPs of compute instances."
}
