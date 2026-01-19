terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-west-3"
}

# Create a VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name="my-vpc"
  }
}
# create a subnet 
resource "aws_subnet" "public"{
  vpc_id= aws_vpc.main.id
  cidr_block= "10.0.1.0/24"
  availability_zone= "eu-west-3a"
  
  tags = {Name="Public"}
}

#create a gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}
#create root table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}
#create a table association 
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

#create aws security group   
resource "aws_security_group" "sg" {
  name        = "allow_ssh_http"
  description = "Allow SSH and HTTP"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
#create a vm instance 
resource "aws_instance" "my_vm" {
  count         = 3
  ami           = "ami-0c94855ba95c71c99" # Debian 11
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public.id
  security_groups = [aws_security_group.sg.name]

  tags = {
    Name = "my-vm-${count.index + 1}"
  }
}
# create a database instance 

resource "aws_db_instance" "my_sql_database" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t2.micro"
  db_name                 = "mydb"
  username             = "admin"
  password             = "Password123!"
  publicly_accessible  = true
  skip_final_snapshot  = true
  vpc_security_group_ids = [aws_security_group.sg.id]
  db_subnet_group_name = aws_db_subnet_group.main.name
}

resource "aws_db_subnet_group" "main" {
  name       = "main-subnet-group"
  subnet_ids = [aws_subnet.public.id]
}


#create DNS (route 53) 
resource "aws_route53_zone" "ma_zone" {
  name = "amine.com"
}

resource "aws_route53_record" "domaine" {
  zone_id = aws_route53_zone.ma_zone.zone_id
  name    = "domaine.amine.com"
  type    = "A"
  ttl     = 300
  records = [for i in aws_instance.my_vm : i.public_ip]
}



