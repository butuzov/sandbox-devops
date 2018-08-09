# Access kes
variable "AWS_ACCESS_KEY" {}

variable "AWS_SECRET_KEY" {}

variable "PRIVATE_KEY_NAME" {}

variable "PRIVATE_KEY_PATH" {}

# Region alias
variable "AWS_REGION" {
  default = "eu-west-1"
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

# Network Addess Space
variable "network_address_space" {
  default = "10.0.1.0/24"
}

variable "subnet_count" {
  default = 1
}

variable "cidr_blocks" {
  default = "0.0.0.0/0"
}
