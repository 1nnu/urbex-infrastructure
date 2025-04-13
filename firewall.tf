resource "hcloud_firewall" "k8sfirewall" {
  name = "my-firewall"
  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "22"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
    description = "Allow ssh through devices from anywhere"
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "30007"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
    description = "Allow access to frontend from anywhere"
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "30008"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
    description = "Allow access to backend from anywhere"
  }

}
