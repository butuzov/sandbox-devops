# ------------------------------------------------------------------------------
# AWS Provider for out credentials in Europe
# ------------------------------------------------------------------------------

provider "aws" {
  access_key = "${var.AWS_ACCESS_KEY}"
  secret_key = "${var.AWS_SECRET_KEY}"
  region     = "${var.AWS_REGION}"
}

# ------------------------------------------------------------------------------
# Anth && Verification
# ------------------------------------------------------------------------------

resource "aws_key_pair" "default" {
  key_name   = "lab_key_pair"
  public_key = "${file(var.PUBLIC_KEY_PATH)}"
}

resource "aws_security_group" "lab-ci-sg" {
  name = "lab-ci-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.cidr_blocks}"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.cidr_blocks}"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${var.cidr_blocks}"]
  }

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["${var.cidr_blocks}"]
  }

  ingress {
    from_port   = 8079
    to_port     = 8099
    protocol    = "tcp"
    cidr_blocks = ["${var.cidr_blocks}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.cidr_blocks}"]
  }
}
