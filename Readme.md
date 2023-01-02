- What is Terraform
    - open sours tool
    - written in Go
    - offered by hashicorp
    - needs not external dependencies
    - makes api calls with porovided credentials to providers
    - 
- AWS Setup
    - is cloud agnostic
    - create aws user or group to perform terraform operations
    - 
- Install Terraform
    - get terraform from hashicorp sit
    - install with 
        - homebrew
        - move executable to /usr/local/bin for linux
- Terraform Settings
    - terraform {
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
    - terraform uses env Variables  set via terraform configure
    - can also be exported if needed
        - export AWS_ ACCESS_KEY ID=access_key_here
export ANS_SECRET_ACCESS_KEY=secrete_key_here
- Deploy Server 1
    - create instance resource for deployment and below
    - resource "aws_instance" "myServer" {
  ami           = "ami-0b5eea76982371e91"
  instance_type = "t2.micro"
  tags = {
    Name = "fisrtServer"
  }
}
    - run Terraform init to download plugins
- 
- Deploy Server 2
    - run Terraform plan to see what will be deployed
    - run terraform apply to deploy infrastructure
    - ami has to exist for deployment to be successful
    - 
- Create Web Server
    - we can create a server by using the 
        - user_data directive within the instance resource
            - adding the following will deploy a simple web server in the instance
            - user_data   `=<<-EOF` 
!#/bin/bash
sudo yum update -y
sudo yum install httpd -y
echo "hello from web server" > /var/www/html/index.html
systemctl start httpd
systemctl enable httd
EOF 

            - will need a security group added in EC2 to be accessible via on port 8080
- Create Web Server 2
    - creating security group resource
        - resource "aws_security_group" "myServer-SG" {
  name = "myServer-SG"
   ingress {
    description      = "Security group for server"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
   
  }
}
        - above can be referenced in the instance resource  via the 
            - vpc_security_group_ids atrribute
        - There should also be an entry for egress traffic to all for access to the internet
            - egress code 
                - egress {
    description      = "outbound traffic for SG"
    from_port        = 0
    to_port          = 0
    protocol         = -1
    cidr_blocks      = ["0.0.0.0/0"] 
  }
    - running terraform plan and apply
        - adds the security group
        - recreates the instance
        - can be accessed via instance ip and port number
- Create Web Server With Variables
    - recommended to use variable to allow for reuse
    - has syntax of 
        - variable "nameOfVariable"{
	description ="variable description "
	default="example t2.micro"
	type = "..."
}
        - can have validation block for allowed values
    - variable for server port can be written like
        - variable "server_port"{
	description ="server port"
	type = number 
	default=80
}
        - can be referenced with 
            - var.server_port 
            - ${var.server_port}
            
    
- outputs 
    - are returned from the infrastructure  after provisioning
        - will be returned by ec2 instance
    - output for public ip address can be obtainer with following :
        - output "publi_ip"{
	description ="server public ip address"
	value = .aws_instance.myServer.public_ip 
}