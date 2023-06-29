
# Use the Ubuntu 18.04 AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

#ec2
resource "aws_instance" "main" {
  ami           = data.aws_ami.ubuntu.id
  instance_type =  "t2.micro" 
  subnet_id     = var.main_subnet_id

  count         =  1 
  associate_public_ip_address = true
  
  # user_data = base64sha256(file("secret.txt"))
  root_block_device {
      encrypted = true
  }
  metadata_options {
     http_tokens = "required"
  } 
  tags = {
    Name = var.name
  }
}
# Security Groups

resource "aws_security_group" "all_ports_to_all" {
  name  = "${var.name}-all_ports_to_all"
  count =  1 
  description = "Security group all port to all"

  vpc_id = var.vpc_id

  ingress {
    description ="just for by pass"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    description ="just for by pass"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["27.73.63.81/32"]#myIP
  }

  egress {
    description ="just for by pass"
    from_port        = 0
    to_port          = 0
    protocol         = -1
    ipv6_cidr_blocks = ["2001:19f0:4401:e03:5400:4ff:fe77:41d4/128"] #myIP
  }
}

resource "aws_security_group" "all_ports_to_self" {
  name  = "${var.name}-all_ports_to_self"
  count =  1 
  description = "Security group all port to self"

  vpc_id = var.vpc_id

  ingress {
    description ="just for by pass"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["27.73.63.81/32"]
    self        = true
  }

  egress {
    description ="just for by pass"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["27.73.63.81/32"]
  }

  egress {
    description ="just for by pass"
    from_port        = 0
    to_port          = 0
    protocol         = -1
    ipv6_cidr_blocks = ["2001:19f0:4401:e03:5400:4ff:fe77:41d4/128"]
  }
}

resource "aws_security_group" "icmp_to_all" {
  name  = "${var.name}-icmp_to_all"
  count =  1 
  description = "Security group icmp to all"
  vpc_id = var.vpc_id


  ingress {
    description ="just for by pass"
    from_port   = 0
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    description ="just for by pass"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["27.73.63.81/32"]
  }

  egress {
    description ="just for by pass"
    from_port        = 0
    to_port          = 0
    protocol         = -1
    ipv6_cidr_blocks = ["2001:19f0:4401:e03:5400:4ff:fe77:41d4/128"]
  }
}
#mai
resource "aws_security_group" "known_port_to_all" {
name  = "${var.name}-known_port_to_all"
count =  1 
description = "known port to all"
vpc_id = var.vpc_id

ingress {
  description = "Allow SSH traffic from 10.0.0.0/16"
  from_port   = 22 # SSH
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["10.0.0.0/16"]
}

ingress {
  description = "Allow SMTP traffic from 10.0.0.0/16"
  from_port   = 25 # SMTP
  to_port     = 25
  protocol    = "tcp"
  cidr_blocks = ["10.0.0.0/16"]
}

ingress {
  description = "Allow NFS traffic from 10.0.0.0/16"
  from_port   = 2049 # NFS
  to_port     = 2049
  protocol    = "tcp"
  cidr_blocks = ["10.0.0.0/16"]
}

ingress {
  description = "Allow MySQL traffic from 10.0.0.0/16"
  from_port   = 3306 # mysql
  to_port     = 3306
  protocol    = "tcp"
  cidr_blocks = ["10.0.0.0/16"]
}

ingress {
  description = "Allow mongodb traffic from 10.0.0.0/16"
  from_port   = 27017 # mongodb
  to_port     = 27017
  protocol    = "tcp"
  cidr_blocks = ["10.0.0.0/16"]
}

ingress {
  description = "Allow MSSQL traffic from 10.0.0.0/16"
  from_port   = 1433 # MsSQL
  to_port     = 1433
  protocol    = "tcp"
  cidr_blocks = ["10.0.0.0/16"]
}

ingress {
  description = "Allow Oracle traffic from 10.0.0.0/16"
  from_port   = 1521 # Oracle DB
  to_port     = 1521
  protocol    = "tcp"
  cidr_blocks = ["10.0.0.0/16"]
}

ingress {
  description = "Allow PostgreSQL traffic from 10.0.0.0/16"
  from_port   = 5432 # PostgreSQL
  to_port     = 5432
  protocol    = "tcp"
  cidr_blocks = ["10.0.0.0/16"]
}

ingress {
  description = "Allow RDP traffic from 10.0.0.0/16"
  from_port   = 3389 # RDP
  to_port     = 3389
  protocol    = "tcp"
  cidr_blocks = ["10.0.0.0/16"]
}

ingress {
  description = "Allow DNS traffic from 10.0.0.0/16"
  from_port   = 53 # DNS
  to_port     = 53
  protocol    = "udp"
  cidr_blocks = ["10.0.0.0/16"]
}

egress {
  description = "Allow outbound traffic to IP address"
  from_port   = 0
  to_port     = 0
  protocol    = -1
  cidr_blocks = ["1.54.238.117/32"]
}

egress {
  description = "Allow outbound traffic to IPv6 address"
  from_port        = 0
  to_port          = 0
  protocol         = -1
  ipv6_cidr_blocks = ["2001:19f0:4401:e03:5400:4ff:fe77:41d4/128"]
}
}

resource "aws_security_group" "opens_plaintext_port" {
name  = "${var.name}-opens_plaintext_port"
count =  1 
description = "opens plaintext port"

vpc_id = var.vpc_id

ingress {
  description = "Allow FTP traffic from 10.0.0.0/16"
  from_port   = 21 # FTP
  to_port     = 21
  protocol    = "tcp"
  cidr_blocks = ["10.0.0.0/16"]
}
#duong
ingress {
    description = "Telnet opens_plainntext_port from VPC"
    from_port   = 23 # Telnet
    to_port     = 23
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    description = "Public port from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["27.73.63.81/32"]
  }

  egress {
    description = "Public port from VPC"
    from_port        = 0
    to_port          = 0
    protocol         = -1
    ipv6_cidr_blocks = ["2001:19f0:4401:e03:5400:4ff:fe77:41d4/128"]
  }
}

resource "aws_security_group" "opens_port_range" {
  name  = "${var.name}-opens_port_range"
  count =  1 
   description = " Allow inbound Opens port range traffic "
  vpc_id = var.vpc_id

  ingress {
     description = "Port 21 from VPC"
    from_port   = 21
    to_port     = 25
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    description = "Public port from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["27.73.63.81/32"]
  }

  egress {
    description = "Public port from VPC"
    from_port        = 0
    to_port          = 0
    protocol         = -1
    ipv6_cidr_blocks = ["2001:19f0:4401:e03:5400:4ff:fe77:41d4/128"]
  }
}

resource "aws_security_group" "opens_port_to_all" {
  name  = "${var.name}-opens_port_to_all"
  count =  1 
 description = " Allow inbound opens_port_to_all traffic" 
  vpc_id = var.vpc_id

  ingress {
    description = " port  21 from VPC"
    from_port   = 21
    to_port     = 21
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    description = "Public port from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["27.73.63.81/32"]
  }

  egress {
    description = "Public port from VPC"
    from_port        = 0
    to_port          = 0
    protocol         = -1
    ipv6_cidr_blocks = ["2001:19f0:4401:e03:5400:4ff:fe77:41d4/128"]
  }
}

resource "aws_security_group" "whitelists_aws_ip_from_banned_region" {
  name  = "${var.name}-whitelists_aws_ip_from_banned_region"
  count =  1 
  description = "Allow inbound whitelists_aws_ip_from_banned_region traffic "
  vpc_id = var.vpc_id

  ingress {
    description = "Public port from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["52.28.0.0/32"] # eu-central-1
  }

  egress {
    description = "Public port from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["27.73.63.81/32"]
  }

  egress {
    description = "Public port from VPC"
    from_port        = 0
    to_port          = 0
    protocol         = -1
    ipv6_cidr_blocks = ["2001:19f0:4401:e03:5400:4ff:fe77:41d4/128"]
  }
}

resource "aws_security_group" "whitelists_aws" {
  name  = "${var.name}-whitelists_aws"
  count =  1 
 description = "Allow inbound whitelists_aws traffic "
  vpc_id = var.vpc_id

  ingress {
    description = "Public port from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["52.14.0.0/32"] # us-east-2
  }

  egress {
    description = "Public port from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["27.73.63.81/32"]
  }

  egress {
    description = "Public port from VPC"
    from_port        = 0
    to_port          = 0
    protocol         = -1
    ipv6_cidr_blocks = ["2001:19f0:4401:e03:5400:4ff:fe77:41d4/128"]
  }
}
#Thai
resource "aws_security_group" "whitelists_unknown_cidrs" {
  name  = "${var.name}-whitelists_unknown_cidrs"
  count =  1 
  description = "just for bypass"

  vpc_id = var.vpc_id 

  ingress {
    description = "Test"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["8.8.8.8/32"]
  }

  egress {
    description = "just for bypass"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["113.185.45.80/32"]
  }

  egress {
    description = "abcd test"
    from_port        = 0
    to_port          = 0
    protocol         = -1
    ipv6_cidr_blocks = ["2001:19f0:4401:e03:5400:4ff:fe77:41d4/128"]
  }
}

resource "aws_security_group" "unused_security_group" {
  name  = "${var.name}-unused_security_group"
  count =  1 
  description = "abcd test"

  ingress {
    description = "abcd"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["8.8.8.8/32"]
  }

  egress {
    description = "abcd test"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["113.185.45.80/32"]
  }

  egress {
    description = "abcd test"
    from_port        = 0
    to_port          = 0
    protocol         = -1
    ipv6_cidr_blocks = ["2001:19f0:4401:e03:5400:4ff:fe77:41d4/128"]
  }
}

resource "aws_security_group" "unneeded_security_group" {
  name  = "${var.name}-unneeded_security_group"
  count =  1 
  description = "abcd test"

  ingress {
    description = "test abcd"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["10.0.0.0/16"]
  }
}

resource "aws_security_group" "unexpected_security_group" {
  name  = "${var.name}-unexpected_security_group"
  count = 1 
  description = "abcd test"

  ingress {
    description = "abcd test"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["127.0.0.0/8"]
  }
}

resource "aws_security_group" "overlapping_security_group" {
  name  = "${var.name}-overlapping_security_group"
  count =  1 
  description = "abcd test"

  ingress {
    description = "abcd test"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["162.168.2.0/32"]
  }

  ingress {
    description = "abcd test"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["162.168.2.0/32"]
  }
}
