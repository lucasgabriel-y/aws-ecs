provider "aws" {
  region = var.region
}
/*
#Cria o recurso para usar uma chave de acesso  
resource "aws_key_pair" "key-pair" {
  key_name   = "${var.recurso}-key"
  public_key = file("/ecs-key.pub")

}

#Cria a instancia EC2
resource "aws_instance" "terraform" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public_subnet.id
  vpc_security_group_ids      = [aws_security_group.public_security_group.id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.key-pair.key_name #Associa a chave de acesso a instancia


  tags = {
    Name = "Teste terraform"
  }

  #Promove o acesso SSH a instancia
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      host        = self.public_ip
      user        = var.user_ssh
      private_key = file("/ecs-key")
    }

    #Promove a instalação de recursos na instancia
    inline = [
      "sudo yum update -y",
      "sudo yum install -y httpd",
      "sudo yum install git -y",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd",
      "git clone https://bitbucket.org/dptrealtime/html-web-app.git",
      "cd html-web-app",
      "sudo cp * -r /var/www/html"
    ]
  }

}

#Associa um IP elastico a uma instancia
resource "aws_eip" "eip" {
  instance = aws_instance.terraform.id
}

#Exibe o IP publico associado
output "IP" {
  value = aws_eip.eip.public_ip

}
*/
resource "aws_ecs_cluster" "my_cluster" {
  name = "my-cluster"
}


resource "aws_ecs_task_definition" "my_task_definition" {
  family = "my-task-family"
  container_definitions = jsonencode([{
    name   = "my-container-name"
    image  = "wordpress:latest"
    cpu    = "256"
    memory = "512"

    portMappings = [
      {
        containerPort = 80
        hostPort      = 80
      }
    ]
  }])
}


resource "aws_ecs_service" "my_service" {
  name            = "my-service"
  cluster         = aws_ecs_cluster.my_cluster.id
  task_definition = aws_ecs_task_definition.my_task_definition.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = [aws_security_group.public_security_group.id]
    subnets         = [aws_subnet.private_subnet.id]
  }
}








