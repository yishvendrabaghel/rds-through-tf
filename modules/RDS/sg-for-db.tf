# resource "aws_security_group" "SecurityGroup" {
#     vpc_id = var.demovpc

#   ingress {
#     from_port = 3306
#     to_port = 3306
#     protocol = "tcp"
#     # cidr_blocks = ["0.0.0.0/0"]
#     security_groups = [var.sg-for-pub-ec2]
#   }

#   egress {
#     from_port = 0
#     to_port = 0
#     protocol = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

# }



resource "aws_security_group" "SecurityGroup" {
  name_prefix = "rds_sg_"
  vpc_id      = var.demovpc

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [var.sg-for-pub-ec2]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}