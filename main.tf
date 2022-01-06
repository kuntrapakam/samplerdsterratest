data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "all" {
  vpc_id = data.aws_vpc.default.id
}

resource "aws_db_subnet_group" "example" {
  name       = "terratestexample"
  subnet_ids = data.aws_subnet_ids.all.ids

  tags = {
    Name = "TERRATEST"
  }
}

resource "aws_security_group" "db_instance" {
  name   = "TERRATESTEXAMPLE"
  vpc_id = data.aws_vpc.default.id
}

resource "aws_db_instance" "default" {
  allocated_storage    = var.allocated_storage
  engine               = var.engine
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  name                 = var.name
  username             = var.username
  password             = var.password
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  publicly_accessible  = true
  port                 = var.port
}

resource "aws_instance" "web" {
  ami           = "ami-061ac2e015473fbe2"
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.web-sg.id]
  user_data = <<EOF
  #!/bin/bash
yum update -y
yum install python3 -y
curl -O https://bootstrap.pypa.io/get-pip.py
python3 get-pip.py
pip3 install --upgrade requests
pip3 install botocore
pip3 install boto3
pip3 install ec2instanceconnectcli
yum install -y https://s3.us-east-1.amazonaws.com/amazon-ssm-us-east-1/latest/linux_amd64/amazon-ssm-agent.rpm

EOF

  tags = {
    Name = "Terratest"
  }
}

resource "aws_security_group" "web-sg" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terratest"
  }
}