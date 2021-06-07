# variables.tf

variable "env" {
  description = "Environment for Infra"
  default     = "dev"
}

variable "app_name" {
  description = "Name of app"
  default     = "webapp"
}

variable "aws_region" {
  description = "The AWS region things are created in"
  default     = "us-east-2"
}

variable "ecs_task_execution_role_name" {
  description = "ECS task execution role name"
  default     = "myEcsTaskExecutionRole"
}

variable "ecs_task_role_name" {
  description = "ECS task role name"
  default     = "myEcsTaskRole"
}

variable "az_count" {
  description = "Number of AZs to cover in a given region"
  default     = "2"
}

variable "app_port" {
  description = "Port exposed by the docker image to redirect traffic to"
  default     = 80
}

variable "app_count" {
  description = "Number of docker containers to run"
  default     = 3
}

variable "health_check_path" {
  default = "/"
}

variable "fargate_cpu" {
  type = number
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = 256
}

variable "fargate_memory" {
  type = number
  description = "Fargate instance memory to provision (in MiB)"
  default     = "512"
}

variable "container_port" {
  type        = number
  description = "Port of docker container"
  default     = 80
}

variable "tag" {
  description = "Tag value to be assigned to all resources"
  default = "Development"
}