
resource "aws_vpc" "ecs_vpc" {
  cidr_block = "10.0.0.0/16" # Bloco de endereços IP da VPC

  tags = {
    Name = "${var.recurso}-_vpc"
  }
}

# Cria uma subnet pública
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.ecs_vpc.id
  cidr_block = "10.0.1.0/24" # Bloco de endereços IP da subnet
  availability_zone = "us-east-2a"
  tags = {
    Name = "public_subnet A"
  }
}

# Cria uma segunda subnet publica
resource "aws_subnet" "public_subnet2" {
  vpc_id     = aws_vpc.ecs_vpc.id
  cidr_block = "10.0.2.0/24" # Bloco de endereços IP da subnet
  availability_zone = "us-east-2b"
  tags = {
    Name = "public_subnet B"
  }
}

# Cria uma subnet privada
resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.ecs_vpc.id
  cidr_block = "10.0.3.0/24" # Bloco de endereços IP da subnet
  availability_zone = "us-east-2c"

  tags = {
    Name = "private_subnet"
  }
}


# Cria um grupo de segurança para a subnet pública
resource "aws_security_group" "public_security_group" {
  name_prefix = "public_security_group"
  vpc_id      = aws_vpc.ecs_vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {

    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {

    description = "HTTP"
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

  tags = {
    Name = "public_security_group"
  }
}


# Cria um gateway de internet para a VPC
resource "aws_internet_gateway" "gateway_internet" {
  vpc_id = aws_vpc.ecs_vpc.id

  tags = {
    Name = "gateway_internet"
  }
}

# Cria uma rota para permitir o tráfego da subnet pública para a Internet
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.ecs_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway_internet.id
  }

  tags = {
    Name = "public_route_table"
  }
}

# Associa a subnet pública com a tabela de rotas pública
resource "aws_route_table_association" "public_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}


# Associa a subnet pública com a tabela de rotas pública
resource "aws_route_table_association" "public_association2" {
  subnet_id      = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.public_route_table.id
}
