# build an entire stack
provider "aws" {
  region = "us-west-1"
}
resource "aws_subnet" "Public-subnet" {
  vpc_id                  = aws_vpc.my-first-vpc.id
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "Dev-subnet"
  }
}
resource "aws_vpc" "my-first-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Dev"
  }
}
resource "aws_internet_gateway" "New_IGW" {
  vpc_id = aws_vpc.my-first-vpc.id
  tags = {
    Name = "this is an IGW"
  }
}
resource "aws_route_table" "vpc_RT" {
  vpc_id = aws_vpc.my-first-vpc.id
}
resource "aws_route_table_association" "RT_association" {
  subnet_id      = aws_subnet.Public-subnet.id
  route_table_id = aws_route_table.vpc_RT.id
}
resource "aws_route_table_association" "IGW-route" {
  gateway_id     = aws_internet_gateway.New_IGW.id
  route_table_id = aws_route_table.vpc_RT.id
}
resource "aws_subnet" "Private_subnet" {
  vpc_id     = aws_vpc.my-first-vpc.id
  cidr_block = "10.0.1.0/24"
  tags = {
    name = "Prod_sub"
  }
}
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "This SG allow ssh traffic for Public-sub"
  vpc_id      = aws_vpc.my-first-vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
  tags = {
    name = "Allow_SSH"
  }
}
resource "aws_key_pair" "Dev_key" {
  key_name   = "lab-test-22"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC//4cHKSsKkDbXjxbMATnKVlYEjxZdJZZbqRh68cdwvGptGUcwqLbhTWymhavSx2mw7fNe0fbNywgJr0w7/fUpzdSVg9RqlGJThcg6pg+UW128xi/sOmyS6FuZOJyqHYUqm+NtBJ7plE22bndd9ZGsXf0QmC0cBHRTcPqRZ24TIV5mo70qRR+zOMqmioJ85uAbCd8rUlJh5HMeF5Mm7e4fKn6DJK/s4Yzi7KoKBHJawd/Ewd7KOdCBC/mSjCBBGdNhZYQfKtNgWp7SSD1TM0VwSlBzIiy5zVk10pEdFjIcr42cAWxaiTOspdGEvMU+I6WvXru3kLcwGoangay3dWFz lab-test-22"
}
# resource "provider" "name" {
#  config options.....
#  key = "value"
#  key2 = "another value" 
# }
