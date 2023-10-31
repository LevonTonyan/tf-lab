resource "aws_security_group" "ssh-inbound" {
  name        = "ssh-inbound"
  description = "allows ssh access from safe IP-range"
  vpc_id      = aws_vpc.vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["141.136.89.231/32"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Terraform = true
    Project   = "epam-tf-lab"
    Owner     = "Levon-Tonyan"
  }
}

resource "aws_security_group" "lb_http-inbound" {
  name        = "lb-http-inbound"
  vpc_id      = aws_vpc.vpc.id
  description = "allows http access from safe IP-range to a LoadBalancer"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["141.136.89.231/32"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Terraform = true
    Project   = "epam-tf-lab"
    Owner     = "Levon-Tonyan"
  }

}

resource "aws_security_group" "http-inbound" {
  name        = "http-inbound"
  vpc_id      = aws_vpc.vpc.id
  description = "allows http access from LoadBalancer"
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.ssh-inbound.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Terraform = true
    Project   = "epam-tf-lab"
    Owner     = "Levon-Tonyan"
  }
}