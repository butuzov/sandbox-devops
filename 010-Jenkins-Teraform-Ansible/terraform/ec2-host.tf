resource "aws_instance" "host" {
  ami                         = "${lookup(var.AMIS, var.AWS_REGION)}"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  availability_zone           = "${data.aws_availability_zones.available.names[0]}"
  security_groups             = ["${aws_security_group.lab-ci-sg.name}"]
  key_name                    = "${aws_key_pair.default.key_name}"

  connection {
    user        = "ec2-user"
    private_key = "${file(var.PRIVATE_KEY_PATH)}"
  }
}

output "host.made.ua" {
  value = "${aws_instance.host.public_ip}"
}
