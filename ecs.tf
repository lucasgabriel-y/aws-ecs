/*
resource "aws_ecs_cluster" "my_cluster" {
  name = "my-cluster"
}


resource "aws_ecs_task_definition" "my_task_definition" {
  family                   = "my-task-family"
  container_definitions    = jsonencode([{
    name  = "my-container-name"
    image = "wordpress:latest"
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




resource "aws_ecs_task_definition" "my_task_definition" {
  family                = "myapp"
  requires_compatibilities = ["FARGATE"]
  network_mode = "awsvpc"
  container_definitions = file("container-definitions.json") 
      name      = "first"
      image     = "service-first"
      cpu       = 10
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]

}


*/