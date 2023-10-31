terraform {

}

provider "aws" {
  region                   = "us-east-1"
}



resource "aws_vpc" "vpc" {
  cidr_block = "10.10.0.0/16"
  tags = {
    Name = "Levon-Tonyan-01-vpc"
  }
}


resource "aws_subnet" "public_a" {
  vpc_id            = aws_vpc.vpc.id
  availability_zone = "us-east-1a"
  cidr_block        = "10.10.1.0/24"
  tags = {
    Name = "Levon-Tonyan-01-subnet-public-a"
  }
}

resource "aws_subnet" "public_b" {
  vpc_id            = aws_vpc.vpc.id
  availability_zone = "us-east-1b"
  cidr_block        = "10.10.3.0/24"
  tags = {
    Name = "Levon-Tonyan-01-subnet-public-b"
  }
}

resource "aws_subnet" "public_c" {
  vpc_id            = aws_vpc.vpc.id
  availability_zone = "us-east-1c"
  cidr_block        = "10.10.5.0/24"
  tags = {
    Name = "Levon-Tonyan-01-subnet-public-c"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "Levon-Tonyan-01-igw"
  }
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "Levon-Tonyan-01-rt"
  }
}


