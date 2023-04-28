resource "aws_ecs_cluster" "this" {
  name = "${var.app_name}-${var.environment}-cluster"
}

resource "aws_ecs_task_definition" "this" {
  family = "${var.app_name}-${var.environment}"
  container_definitions = jsonencode([{
    name      = var.app_name
    image     = var.docker_image_uri
    essential = true
    portMappings = [
      {
        containerPort = 8888
        hostPort      = 8888
      }
    ]
    environment = [
      {
        name  = "ENV"
        value = var.environment
      },
      {
        name  = "MYSQL"
        value = "${var.db_instance_username}:${var.db_instance_password}@tcp(${var.db_instance_endpoint})/${var.db_name}_${var.environment}?charset=utf8&parseTime=True&loc=Local"
      }
    ]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = aws_cloudwatch_log_group.ecs_log_group.name
        "awslogs-stream-prefix" = "my-task-logs"
        "awslogs-region"        = var.region
      }
    }
  }])
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = var.ecs_execution_role_arn
  task_role_arn            = var.ecs_task_role_arn
}
resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = "my-log-group"
  retention_in_days = 14
}

resource "aws_ecs_service" "this" {
  name            = "${var.app_name}-${var.environment}"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = var.vpc_security_group_ids
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.this.arn
    container_name   = var.app_name
    container_port   = 8888
  }

  depends_on = [aws_lb_listener.this]
}

resource "aws_lb" "this" {
  name               = "${var.app_name}-${var.environment}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.vpc_security_group_ids
  subnets            = var.subnet_ids
  timeouts {
    create = "20m"
  }
}

resource "aws_lb_target_group" "this" {
  name        = "${var.app_name}-${var.environment}-target-group"
  port        = 8888
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    enabled             = true
    healthy_threshold   = 3
    interval            = 30
    matcher             = "200"
    path                = "/checkout/v1/number"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 3
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = 8888
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }

  lifecycle {
    create_before_destroy = true
  }
}
