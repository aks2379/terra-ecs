resource "aws_ecr_repository" "main" {
  name = "${var.env}-${var.app_name}-repo"
  tags = {
    Environment = "Development"
  }
}
