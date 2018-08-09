resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "${var.cidr_blocks}"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags {
    Name = "rtb-public"
  }
}

resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.vpc.id}"

  count = "${var.subnet_count}"

  route {
    cidr_block     = "${var.cidr_blocks}"
    nat_gateway_id = "${element(aws_nat_gateway.nat.*.id, count.index)}"
  }

  tags {
    Name = "rtb-private-${count.index}"
  }
}
