locals {
  current_timestamp = timestamp()
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web" {
  ami                    = data.aws_ami.ubuntu.id
  ## Sentinel will fail the below, due to it not being in the list found within https://github.com/JPurcellHCP/jpp-sentinel-demo/blob/main/policies/restrict-ec2-instance-type.sentinel
  instance_type          = "t3.large"
  ## The below instance type would pass
  ## instance_type = "t3.medium"
  vpc_security_group_ids = ["${aws_security_group.allow_ssh.id}"]

  tags = {
    Name = "Sentinel-Demo-JP"
    "Owner" = "JamesPurcell"
    "Created" = formatdate("DD-MM-YY" ,local.current_timestamp)
    "TTL" = "7"
  }
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"

  ingress {
    description      = "SSH from world"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    ## The below CIDR block will fail https://github.com/JPurcellHCP/jpp-sentinel-demo/blob/main/policies/restrict-ingress-sg-rule-ssh.sentinel
    cidr_blocks      = ["0.0.0.0/0"]
    ## The below CIDR block will pass
    ## cidr_blocks = [10.0.0.0/16]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    "Name" = "Sentinel-Demo-JP"
    "Owner" = "JamesPurcell"
    "Created" = formatdate("DD-MM-YY" ,local.current_timestamp)
    "TTL" = "7"
  }
}