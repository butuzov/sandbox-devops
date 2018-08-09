resource "aws_instance" "ci" {
  ami           = "${lookup(var.AMIS, var.AWS_REGION)}"
  instance_type = "t2.small"

  associate_public_ip_address = true
  availability_zone           = "${data.aws_availability_zones.available.names[0]}"
  security_groups             = ["${aws_security_group.lab-ci-sg.name}"]

  key_name = "${aws_key_pair.default.key_name}"

  connection {
    user        = "ec2-user"
    private_key = "${file(var.PRIVATE_KEY_PATH)}"
  }

  // ansible
  provisioner "file" {
    source      = "shared/ansible"
    destination = "~"
  }

  provisioner "remote-exec" {
    inline = [
      "sed -i -e s/_host_/${aws_instance.host.public_ip}/ ~/ansible/inventory",
    ]
  }

  provisioner "file" {
    source      = "${var.PRIVATE_KEY_PATH}"
    destination = "~/ansible/private_key"
  }

  // jenkins
  provisioner "file" {
    source      = "shared/jenkins/install.sh"
    destination = "install-jenkins-plugins.sh"
  }

  provisioner "file" {
    source      = "shared/jenkins/plugins.txt"
    destination = "plugins.txt"
  }

  provisioner "file" {
    source      = "ec2-ci.sh"
    destination = "jenkins.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x ~/jenkins.sh",
      "./jenkins.sh",
    ]
  }

  // ~* Nginx *~

  provisioner "file" {
    source      = "www-data"
    destination = "~"
  }
  provisioner "file" {
    source      = "shared/nginx/nginx.conf"
    destination = "nginx.conf"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo yum install nginx -y",
      "sed -i -e s/__PORT__/8080/ nginx.conf",
      "sed -i -e s/__DOMAIN__/ci-/ nginx.conf",
      "sudo mv ~/nginx.conf /etc/nginx/nginx.conf",
      "sudo service nginx start",
      "sudo chkconfig nginx on",
    ]
  }
  depends_on = ["aws_instance.host"]
}

output "ci.made.ua" {
  value = "${aws_instance.ci.public_ip}"
}
