#
resource "aws_vpc" "vpc" {
  cidr_block = "${var.network_address_space}"

  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags {
    Name = "vpc-demo"
  }
}
