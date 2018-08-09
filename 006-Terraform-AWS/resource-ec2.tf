resource "aws_instance" "web" {
  count         = "${var.subnet_count}"
  ami           = "${lookup(var.AMIS, var.AWS_REGION)}"
  instance_type = "t2.micro"

  security_groups        = ["${aws_security_group.sg-web.id}"]
  vpc_security_group_ids = ["${aws_security_group.sg-web.id}"]
  subnet_id              = "${element(aws_subnet.public.*.id, count.index)}"

  associate_public_ip_address = true

  key_name = "${var.PRIVATE_KEY_NAME}"

  connection {
    user        = "ec2-user"
    private_key = "${file(var.PRIVATE_KEY_PATH)}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install nginx -y",
      "sudo yum install php php-mysql php-fpm -y",
    ]
  }

  provisioner "file" {
    source      = "data/nginx.conf"
    destination = "/home/ec2-user/nginx.conf"
  }

  provisioner "file" {
    source      = "data/php-www.conf"
    destination = "/home/ec2-user/www.conf"
  }

  provisioner "file" {
    source      = "data/index.php"
    destination = "/home/ec2-user/index.php"
  }

  provisioner "file" {
    source      = "data/php.ini"
    destination = "/home/ec2-user/php.ini"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo cp /home/ec2-user/php.ini /etc/php.ini",
      "sudo cp /home/ec2-user/nginx.conf /etc/nginx/nginx.conf",
      "sudo cp /home/ec2-user/www.conf /etc/php.d/www.conf",
      "sudo cp /home/ec2-user/index.php /usr/share/nginx/html/index.php",
      "sudo service nginx start",
      "sudo service php-fpm start",
    ]
  }

  tags {
    Name = "web-${count.index+1}"
  }
}

output "aws_instance_ips" {
  value = ["${aws_instance.web.*.public_ip}"]
}
