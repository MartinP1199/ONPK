# --- root/providers.tf ---

# Define required providers
terraform {
#required_version = ">= 0.14.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
    }
  }
}

# Configure the OpenStack Provider
provider "openstack" {
  user_name   = var.user_name
  tenant_name = var.tenant_name
  password    = var.password
  region      = local.kis_os_region
  auth_url    = local.kis_os_auth_url
  insecure    = true
  endpoint_overrides = local.kis_os_endpoint_overrides
}

