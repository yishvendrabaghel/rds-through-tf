terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}
module "instance" {
  source        = "./modules/instances"
  name-pub      = "Yishu-pub"
  demovpc       = module.VPC.demovpc
  pub-ami       = "ami-053b0d53c279acc90"
  pub-ins_type  = "t2.micro"
  ec2_key_name  = "key"
  public-subnet = module.VPC.public-subnet


  #EC2 in private subnet
  name-pvt        = "Yishu-pvt"
  pvt-ami         = "ami-053b0d53c279acc90"
  pvt-ins_type    = "t2.micro"
  private-subnet  = module.VPC.private-subnet
  ec2_pvt-keyname = "pvt_key"
  #   role-name       = module.iam.role-name

}

module "VPC" {
  source           = "./modules/vpc"
  name             = "Yishu"
  subnets-you-want = 3
  CIDR_block       = "10.0.0.0/16"
  # public-cidr       = "10.0.[${count.index}].0/24"
  # private-cidr      = "10.0.[${127 + count.index}].0/24"
  # availability_zone = "us-east-1a"
}

module "rds" {
  source            = "./modules/RDS"
  allocated_storage = 20
  storage_type      = "gp2"
  engine            = "mysql"
  engine_version    = "5.7"
  instance_class    = "db.t2.micro"
  # name                 = "mydb"
  username             = "admin"
  password             = "password123"
  parameter_group_name = "default.mysql5.7"
  db-subnet-grp        = module.VPC.db-subnet-grp
  demovpc              = module.VPC.demovpc
  sg-for-pub-ec2       = module.instance.sg-for-pub-ec2
}