# getting aviability zones list
data "aws_availability_zones" "available" {}

# data "external" "ip" {
#   program = ["bash", "dig +short myip.opendns.com @resolver1.opendns.com"]
# }

