terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>4.0"
    }
  }
  backend "s3" {
    key = "aws/ec2-depoy/terraform.tfstate"
  }
}

provider "aws" {
  # region  = var.region
  region  = "us-east-2"
  # profile = "terraform"
}

resource "aws_instance" "appserver" {
  ami                    = var.ubuntu_ami
  instance_type          = var.instance_type
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.sg_public.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.role
  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = var.private_key
    timeout     = "4m"
  }
  tags = {
    "Name" = "Node_server"
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = var.key_name
  public_key = var.public_key
}

resource "aws_security_group" "sg_public" {
  name = "Security group for nodejs server"

  egress {
    description      = ""
    cidr_blocks      = ["0.0.0.0/0"]
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    ipv6_cidr_blocks = []
    security_groups  = []
    self             = false
    prefix_list_ids  = []
  }
  ingress = [
    {
      description      = ""
      cidr_blocks      = ["0.0.0.0/0"]
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      security_groups  = []
      self             = false
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
    },
    {
      description      = ""
      cidr_blocks      = ["0.0.0.0/0"]
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      security_groups  = []
      self             = false
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
    }
  ]
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_profile"
  role = "EC2-ECR-AUTH-READONLY"
}

output "instance_public_ip" {
  value     = aws_instance.appserver.private_ip
  sensitive = true
}