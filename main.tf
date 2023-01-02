terraform {
  required_version = "1.3.6"
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}


variable "server_port" {
  description = "port to use for accessing site"
  type = number
  default = 80
}

resource "aws_instance" "myWebServer" {
  ami                    = "ami-0b5eea76982371e91"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.myServer.id]
  user_data              = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install httpd -y
    echo "<h1>Hello from the webServer</h1>" >/var/www/html/index.html
    systemctl start httpd
    systemctl enable httpd
  EOF  
  tags = {
    Name      = "WebServer"
    createdBy = "Jeffrey"
  }
}

resource "aws_security_group" "myServer" {
  name = "myServer-SG"
  ingress {
    description = "Security group for server"
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ssh access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    description = "outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "public_ip" {
  description = "public ip address of server"
  value = aws_instance.myWebServer.public_ip
}
