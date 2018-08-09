resource "aws_network_acl" "acl-frontend" {
  vpc_id = "${aws_vpc.vpc.id}"

  subnet_ids = ["${aws_subnet.public.*.id}"]

  # allow inbound 80/443
  ingress {
    rule_no    = 10
    from_port  = 22
    to_port    = 22
    action     = "allow"
    protocol   = "tcp"
    cidr_block = "${var.cidr_blocks}"
  }

  ingress {
    rule_no    = 20
    from_port  = 80
    to_port    = 80
    action     = "allow"
    protocol   = "tcp"
    cidr_block = "${var.cidr_blocks}"
  }

  ingress {
    rule_no    = 30
    from_port  = 443
    to_port    = 443
    action     = "allow"
    protocol   = "tcp"
    cidr_block = "${var.cidr_blocks}"
  }

  ingress {
    rule_no    = 40
    from_port  = 1024
    to_port    = 65535
    action     = "allow"
    protocol   = "tcp"
    cidr_block = "${var.cidr_blocks}"
  }

  #allow all outbound
  egress {
    rule_no    = 10
    from_port  = 0
    to_port    = 0
    action     = "allow"
    protocol   = "-1"
    cidr_block = "${var.cidr_blocks}"
  }

  tags {
    Name = "acl-frontend"
  }
}
