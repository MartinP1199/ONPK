# --- root/variables.tf ---

variable "user_name" {
    type = string
}

variable "password" {
    type = string
}

variable "tenant_name" {
    type = string
    default = "ONPK_15"
}

variable "project" {
  type = string
  default = "terrabuntu"
}

variable "security_group_id" {
  type = string
  default = "secgroup_terrabuntu"
}

variable "script_file_path" {
  type = string
  default = "scrips/script.sh"
}
