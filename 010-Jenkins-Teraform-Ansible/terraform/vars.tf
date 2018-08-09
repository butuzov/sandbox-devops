# ------------------------------------------------------------------------------
# Data Sources and rest of Vars
# ------------------------------------------------------------------------------

data "aws_availability_zones" "available" {}

variable "cidr_blocks" {
  default = "0.0.0.0/0"
}

variable "network_address_space" {
  default = "10.0.0.0/16"
}

variable "AWS_REGION" {
  default = "eu-central-1"
}

# AMI - Amazon Linux AMI 2018.03.0
variable "AMIS" {
  type = "map"

  default = {
    eu-central-1 = "ami-9a91b371"
    eu-west-1    = "ami-ca0135b3"
    eu-west-2    = "ami-a36f8dc4"
    eu-west-3    = "ami-969c2deb"
  }
}

variable "AWS_ACCESS_KEY" {
  default = "APIAIPNFUCKUALOAWUDAQ"
} # AWS ACCESS KEY

variable "AWS_SECRET_KEY" {
  default = "9b+HwaV51t_d0sNt_VvORK_0_l0l_uULZ4s3teS9U9sXVK"
} # AWS SECRET KEY

variable "PRIVATE_KEY_PATH" {
  default = "shared/.ssh/ssh-private-key"
} # SSH PRIVATE KEY

variable "PUBLIC_KEY_PATH" {
  default = "shared/.ssh/ssh-private-key.pub"
} # SSH PUBLIC KEY
