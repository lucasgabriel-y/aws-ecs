provider "aws" {
  region = var.region
}

resource "aws_ecs_cluster" "my_cluster" {
  name = "my-cluster"
}


resource "aws_ecs_task_definition" "my_task_definition" {
  family                = "myapp"
  #requires_compatibilities = ["FARGATE"]
  network_mode = "awsvpc"
  cpu       = 1024
  memory    = 2048
  container_definitions = jsonencode([
    {
        name      = "wordpress"
        image     = "wordpress"
        cpu       = 1024
        memory    = 2048
        essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])
}

  


resource "aws_ecs_service" "my_service" {
  name            = "my-service"
  cluster         = aws_ecs_cluster.my_cluster.id
  task_definition = aws_ecs_task_definition.my_task_definition.arn
  desired_count   = 1
  launch_type     = "FARGATE"
#https://earthly.dev/blog/deploy-dockcontainers-to-awsecs-using-terraform/

  network_configuration {
    security_groups  = [aws_security_group.public_security_group.id]
    subnets          = [aws_subnet.public_subnet.id]
    assign_public_ip = true
  }
}








