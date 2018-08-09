resource "aws_elb" "lb" {
  name            = "lbdemo"
  subnets         = ["${aws_subnet.public.*.id}"]
  security_groups = ["${aws_security_group.sg-lb.id}"]
  instances       = ["${aws_instance.web.*.id}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  #   listener {
  #     instance_port     = 443
  #     instance_protocol = "https"
  #     lb_port           = 443
  #     lb_protocol       = "https"
  #   }

  tags {
    Name = "lb"
  }
}

output "aws_elb_arn" {
  value = "${aws_elb.lb.arn}"
}

output "aws_elb_dns_name" {
  value = "${aws_elb.lb.dns_name}"
}
