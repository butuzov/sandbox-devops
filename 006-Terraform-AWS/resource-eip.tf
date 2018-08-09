resource "aws_eip" "nat" {
  vpc   = true
  count = "${var.subnet_count}"
}
