variable "vm_name" {
  type        = string
  description = "The name of the virtual machine"
  default     = "machine"
}

variable "vm_image" {
  type        = string
  description = "The VM image to use"
  default     = "ubuntu"

}
variable "vm_size" {
  type        = string
  description = "The size of the virtual machine"
  default     = "Standard_D2s_v3"
}
variable "admin_username" {
  type         = string
  description = "The name of the virtual machine"
  default     = "lokesh"

}
variable "admin_password" {
  type         = string
  description = "The name of the virtual machine"
  default     = "sunaki"

}