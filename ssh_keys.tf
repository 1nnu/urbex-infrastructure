resource "hcloud_ssh_key" "main" {
  name       = "urbex-key"
  public_key = file("${path.module}/id_ed25519.pub")
}