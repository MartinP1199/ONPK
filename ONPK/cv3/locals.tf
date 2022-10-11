# -- root/locals.tf ---

locals {
  
  # --- key ---
  key = ""

  # --- local ---
  local_subnet = "192.168.0.0/16"

  # --- home ---
  home_public_ip = "158.255.30.130/32"
  home_isp_net = "158.255.30.130"

  # --- uniza ---
  uniza_network = "158.193.0.0/16"

  # --- uniza fri kis ---
  kis_os_region = "RegionOne"
  kis_os_auth_url = "http://158.193.138.33:5000/v3"
  kis_os_endpoint_overrides = {
    network = "http://158.193.138.33:9696/v2.0/"
    compute = "http://158.193.138.33:8774/v2.1/86c3984a8c7a48bc8caa5aa4a8ec3da1/"
  }
}