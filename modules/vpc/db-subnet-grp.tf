# resource "aws_db_subnet_group" "default" {
#   name       = "main"
#   subnet_ids = ["aws_subnet.private-subnet[0].id",
#                 "aws_subnet.private-subnet[1].id",
#                 "aws_subnet.private-subnet[2].id"]

#   tags = {
#     Name = "My DB subnet group"
#   }
# }


# modules/vpc/db-subnet-grp.tf

resource "aws_db_subnet_group" "default" {
  name       = "my-db-subnet-group"
  subnet_ids = [
    aws_subnet.private-subnet[1].id,
    aws_subnet.private-subnet[2].id,
    aws_subnet.private-subnet[0].id,
  ]
}
