# ecs.tf

resource "aws_ecs_cluster" "main" {
  name = "myapp-cluster"
  tags = {
    Environment = "Development"
  }
}



resource "aws_ecs_task_definition" "app" {
  family                   = "myapp-task"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  container_definitions = jsonencode([{
    "name" : "${var.env}-${var.app_name}-container",
    "image" : "${aws_ecr_repository.main.repository_url}:latest",
    "cpu" : var.fargate_cpu,
    "memory" : var.fargate_memory,
    "networkMode" : "awsvpc",
    "logConfiguration" : {
      "logDriver" : "awslogs",
      "options" : {
        "awslogs-group" : "/ecs/myapp",
        "awslogs-region" : var.aws_region,
        "awslogs-stream-prefix" : "ecs"
      }
    },
    "portMappings" : [
      {
        "containerPort" : var.container_port,
        "hostPort" : var.container_port
      }
    ]
  }])

  tags = {
    Environment = "Development"
  }
}

resource "aws_ecs_service" "main" {
  name            = "${var.env}-${var.app_name}-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.ecs_tasks.id]
    subnets          = aws_subnet.private.*.id
    assign_public_ip = true

  }

  load_balancer {
    target_group_arn = aws_alb_target_group.app.id
    container_name   = "${var.env}-${var.app_name}-container"
    container_port   = var.app_port
  }

  depends_on = [aws_alb_listener.front_end]
}


# ECS task execution role
resource "aws_iam_role" "ecs_task_execution_role" {
  name               = var.ecs_task_execution_role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
  tags = {
    Environment = "Development"
  }
}

# ECS task execution role data
data "aws_iam_policy_document" "assume_role_policy" {
  version = "2012-10-17"
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

# ECS task execution role policy attachment
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"

}



# ECS task role
resource "aws_iam_role" "ecs_task_role" {
  name               = var.ecs_task_role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
  tags = {
    Environment = "Development"
  }
}