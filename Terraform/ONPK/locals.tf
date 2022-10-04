# -- root/locals.tf ---

locals {
  kis_os_region = "RegionOne"
  kis_os_auth_url = "http://158.193.138.33:5000/v3"
  kis_os_endpoint_overrides = {
    network = "http://158.193.138.33:9696/v2.0/"
    compute = "http://158.193.138.33:8774/v2.1/86c3984a8c7a48bc8caa5aa4a8ec3da1/"
  }
}