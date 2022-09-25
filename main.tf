#Gateway
resource "aws_internet_gateway" "client-gw" {
  vpc_id = var.client_vpc

  tags = {
    Name = var.client_name
  }
}

#Route Table for Gateway
resource "aws_route_table" "client_route_table" {
  vpc_id = aws_vpc.var.client_vpc.id

  route {
    cidr_block = var.cidr_block
    gateway_id = aws_internet_gateway.client-gw.id
  }

  tags = {
    Name = var.client_name
  }
}

#subnet for dev VPC
resource "aws_subnet" "client_subnet" {
  vpc_id            = aws_vpc.var.client_vpc.id
  cidr_block        = var.cidr_block
  availability_zone = var.availability_zone

  tags = {
    Name = var.client_name
  }
}


#associate route table with subnet
resource "aws_route_table_association" "client_association" {
  subnet_id      = aws_subnet.client_subnet.id
  route_table_id = aws_route_table.client_route_table.id
}

#create security group to restrict and allow only certain ports
resource "aws_security_group" "client_allow_web" {
  name        = "allow_web_traffic"
  description = "Allow web traffic"
  vpc_id      = aws_vpc.var.client_vpc.id

  ingress {
    description = "HTTPS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_block  = var.cidr_block
  }

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_block  = var.cidr_block
  }

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_block  = var.cidr_block
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.client_name
  }
}

#network interface for web server
resource "aws_network_interface" "client_web-server-nic" {
  subnet_id       = aws_subnet.client_subnet.id
  private_ips     = var.private_ips
  security_groups = [aws_security_group.client_allow_web.id]
}

# Elastic IP for web server
resource "aws_eip" "client_one" {
  vpc                       = true
  network_interface         = aws_network_interface.client_web-server-nic.id
  associate_with_private_ip = var.private_ips
  depends_on = [
    aws_internet_gateway.client-gw
  ]
}

#--------------------------------------- Instances -------------------------------------------------------------------
resource "aws_instance" "client_web-server-instance" {
  ami               = var.client_ami
  instance_type     = var.client_instance_type
  availability_zone = var.availability_zone
  key_name          = var.key_name

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.client_web-server-nic.id
  }

  user_data = var.user_data_template

  tags = {
    Name = var.client_name
  }
}