variable "env" {
  type        = string
  description = "Environment for Infra"
  default     = "dev"
}

variable "aws_region" {
  type        = string
  description = "AWS region for infra"
  default     = "us-east-2"
}