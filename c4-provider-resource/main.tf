provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = "us-west-2"
}

provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = "us-east-1"
  alias      = "backup"
}

variable "access_key" {}
variable "secret_key" {}

# resource "aws_instance" "web01" {
#   availability_zone = "us-west-2a"
#   ami               = data.aws_ami.ubuntu.id
#   instance_type     = "t2.micro"
#   depends_on        = [aws_network_interface.foo]
#   network_interface {
#     network_interface_id = aws_network_interface.foo.id
#     device_index         = 0
#   }
#   tags = {
#     env = "prod"
#   }
# }
