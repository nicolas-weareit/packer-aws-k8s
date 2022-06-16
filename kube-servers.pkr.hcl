packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  ami_name          = "${ var.ami_name }"
  ami_description   = "${ var.ami_description }"
  instance_type     = "t2.micro"
  region            = "${ aws_region }"
  tags              = {
      OS_VERSION = "Ubuntu"
      Release = "Latest"
      Version = "${ var.version_number }"
      Release_Date = formatdate("YY-MM-DD",timestamp())    
  }
  force_deregister = true
  force_delete_snapshot = true
  snapshot_tags = {
    AMI = "${ var.ami_name }"
  }
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-jammy-22.04-amd64-server-*" 
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["${ var.source_ami_owner }"]
  }
  ssh_username = "ubuntu"
}

build {
  name = "k8s-packer"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]
  provisioner "shell" {
      script = "scripts/update.sh"
      execute_command = "sudo -S sh -c '{{ .Vars }} {{ .Path }}'"
      expect_disconnect = true
      valid_exit_codes = [0,100]
  }

  provisioner "shell" {
      script = "scripts/install-k8s.sh"
      execute_command = "sudo -S sh -c '{{ .Vars }} {{ .Path }}'"
      expect_disconnect = true
  }
}