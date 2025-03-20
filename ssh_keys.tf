resource "hcloud_ssh_key" "main" {
  name       = "terraform_ssh"
  public_key = file("~/.ssh/id_ed25519.pub")
}