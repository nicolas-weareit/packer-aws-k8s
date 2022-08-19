variable "ssh_private_key" {
  type =  string
  default = ""
  // Sensitive vars are hidden from output as of Packer v1.6.5
  sensitive = true
}

variable "ami_name" {
  type = string
  default = ""
  description = "Name of the AMI to create"
}

variable "ami_description" {
  type = string
  default = ""
  description = "Description of the AMI to create"
}

variable "source_ami_owner" {
  type = string
  default = ""
  description = "Source AMI Owner ID"
}

variable "aws_region" {
  type = string
  default = ""
}

variable "version_number" {
  type = string
  default = "0.1"
}