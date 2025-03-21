variable "hcloud_token" {
  type        = string
  sensitive   = true
}

variable "location" {
  default = "hel1"
}

variable "datacenter" {
  default = "hel1-dc2"
}

variable "instances" {
  default = "1"
}

variable "server_type" {
  default = "cx22"
}

variable "os_type" {
  default = "ubuntu-24.04"
}
