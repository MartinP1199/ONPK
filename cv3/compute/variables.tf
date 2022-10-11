variable "project" {
  type = string
}

variable "enviroment" {
  type = string
}

variable "name" {
  type = string
}

variable "image_id" {
  type = string
  default = "0fc1152a-4037-4d89-a22a-60f477e2eba0"
}

variable "flavor_id" {
  type = string
  default = "1eee6fc3-f274-4406-a054-1969ac79926f"
}

#variable "key_pair_name" {
  #type = string
#}

variable "remote_ip_prefix" {
  type = string
}

#variable "security_group_id" {
#  type = string
#}

variable "script_file_path" {
  type = string
}

variable "instances_count" {
  type = number
  default = 1
}