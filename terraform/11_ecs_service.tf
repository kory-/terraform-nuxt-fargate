#####################################
# ECS Service Setting
#####################################
resource "aws_ecs_service" "this" {
  name            = "${local.app_name}-service"
  cluster         = "${aws_ecs_cluster.this.id}"
  task_definition = "arn:aws:ecs:ap-northeast-1:${data.aws_caller_identity.this.account_id}:task-definition/${aws_ecs_task_definition.main.family}"
  desired_count   = 1
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = "${aws_lb_target_group.http.arn}"
    container_name   = "rp"
    container_port   = 8080
  }

  network_configuration {
    subnets = [
      "${aws_subnet.ecs_a.id}",
      "${aws_subnet.ecs_c.id}",
    ]

    security_groups = [
      "${aws_security_group.ecs.id}",
    ]

    assign_public_ip = true
  }

  depends_on = [
    "aws_lb_listener.http",
    "aws_lb_listener.https",
  ]
}
