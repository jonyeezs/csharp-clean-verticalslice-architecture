locals {
  executionRole_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  ]
}

resource "aws_iam_role" "task_execution" {
  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : "sts:AssumeRole",
          "Principal" : {
            "Service" : "ecs-tasks.amazonaws.com"
          },
          "Effect" : "Allow",
          "Sid" : "ECSTaskExecutionAssumeRole"
        }
      ]
    }
  )
}

resource "aws_iam_role_policy_attachment" "task" {
  count      = length(local.executionRole_arns)
  role       = aws_iam_role.task_execution.name
  policy_arn = element(local.executionRole_arns, count.index)
}
