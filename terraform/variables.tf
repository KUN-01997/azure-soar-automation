variable "admin_username" {
  type        = string
  description = "Admin username for the Windows VM"
}

variable "admin_password" {
  type        = string
  sensitive   = true
  description = "Admin password (must meet Azure complexity requirements)"
}

variable "allowed_ip" {
  type        = string
  description = "Public IP allowed to RDP into the VM (in CIDR format, e.g., 1.2.3.4/32)"
}
