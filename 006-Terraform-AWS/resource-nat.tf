resource "aws_nat_gateway" "nat" {
  count         = "${var.subnet_count}"
  allocation_id = "${element(aws_eip.nat.*.id, count.index)}"
  subnet_id     = "${element(aws_subnet.public.*.id, count.index)}"
  depends_on    = ["aws_internet_gateway.igw"]
}

output "nat_ids" {
  value = ["${aws_nat_gateway.nat.*.id}"]
}

output "nat_ips" {
  value = ["${aws_nat_gateway.nat.*.public_ip}"]
}
