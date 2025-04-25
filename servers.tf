# Create primary ip for load balancer node access
resource "hcloud_primary_ip" "load_balancer_ip" {
  name          = "load_balancer_primary_ip"
  datacenter    = var.datacenter
  type          = "ipv4"
  assignee_type = "server"
  auto_delete   = false
}

# Create primary ip for control node access
resource "hcloud_primary_ip" "control_node_ip" {
  name          = "control_node_primary_ip"
  datacenter    = var.datacenter
  type          = "ipv4"
  assignee_type = "server"
  auto_delete   = false
}

# Create primary ip for worker node access
resource "hcloud_primary_ip" "worker_node_ip" {
  name          = "worker_node_primary_ip"
  datacenter    = var.datacenter
  type          = "ipv4"
  assignee_type = "server"
  auto_delete   = false
}

# Create load balancer node running Ubuntu
resource "hcloud_server" "load_balancer" {
  name        = "load-balancer"
  image       = var.os_type
  server_type = var.server_type
  location    = var.location
  ssh_keys    = [hcloud_ssh_key.main.id]
  firewall_ids = [hcloud_firewall.k8sfirewall.id]
  labels  	  = {
    "node_type" : "balancer"
  }

  network {
    network_id = hcloud_network.privateNetwork.id
    ip         = "192.168.0.10"
  }

  public_net {
    ipv4_enabled = true
    ipv4 = hcloud_primary_ip.load_balancer_ip.id
    ipv6_enabled = false
  }

  depends_on = [
    hcloud_network_subnet.k8s
  ]
}

# Create control node running Ubuntu
resource "hcloud_server" "control_node" {
  name        = "control-node"
  image       = var.os_type
  server_type = var.server_type
  location    = var.location
  ssh_keys    = [hcloud_ssh_key.main.id]
  firewall_ids = [hcloud_firewall.k8sfirewall.id]
  labels  	  = {
    "node_type" : "control"
  }

  network {
    network_id = hcloud_network.privateNetwork.id
    ip         = "192.168.0.11"
  }

  public_net {
    ipv4_enabled = true
    ipv4 = hcloud_primary_ip.control_node_ip.id
    ipv6_enabled = false
  }

  depends_on = [
    hcloud_network_subnet.k8s
  ]
}

# Create worker node running Ubuntu
resource "hcloud_server" "worker_node" {
  name        = "worker-node"
  image       = var.os_type
  server_type = var.server_type
  location    = var.location
  ssh_keys    = [hcloud_ssh_key.main.id]
  firewall_ids = [hcloud_firewall.k8sfirewall.id]
  labels  	  = {
    "node_type" : "worker"
  }

  network {
    network_id = hcloud_network.privateNetwork.id
    ip         = "192.168.0.12"
  }

  public_net {
    ipv4_enabled = true
    ipv4 = hcloud_primary_ip.worker_node_ip.id
    ipv6_enabled = false
  }

  depends_on = [
    hcloud_network_subnet.k8s
  ]
}
