# Public Subnets

resource "aws_subnet" "public" {
  count                   = "${var.subnet_count}"
  cidr_block              = "${cidrsubnet(var.network_address_space, 4, count.index + 1 )}"
  vpc_id                  = "${aws_vpc.vpc.id}"
  map_public_ip_on_launch = "true"
  availability_zone       = "${data.aws_availability_zones.available.names[count.index % 3]}"

  tags {
    Name = "public-${count.index + 1}"
  }
}

# Private Subnets

resource "aws_subnet" "private" {
  count             = "${var.subnet_count}"
  cidr_block        = "${cidrsubnet(var.network_address_space, 4, count.index + 1 + var.subnet_count)}"
  vpc_id            = "${aws_vpc.vpc.id}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index % 3]}"

  tags {
    Name = "private-${count.index + 1}"
  }
}
