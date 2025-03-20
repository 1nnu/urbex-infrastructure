# Create primary ip for server access
resource "hcloud_primary_ip" "main" {
  name          = "primary_ip"
  datacenter    = var.datacenter
  type          = "ipv4"
  assignee_type = "server"
  auto_delete   = false
}

# Create main node running Ubuntu
resource "hcloud_server" "main" {
  name        = "node1"
  image       = var.os_type
  server_type = var.server_type
  location    = var.location
  ssh_keys    = [hcloud_ssh_key.main.id]
  public_net {
    ipv4_enabled = true
    ipv4 = hcloud_primary_ip.main.id
    ipv6_enabled = false
  }
}
