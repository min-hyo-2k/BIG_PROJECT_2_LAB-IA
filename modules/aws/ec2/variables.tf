variable "name" {
  description = "Name for instances and group"
  type        = string
  default     = "sadcloud-ec2"
}

############## Network ##############

variable "vpc_id" {
  description = "ID of created VPC"
  default = "vpc-000af707fadc0e7f7"
}

variable "main_subnet_id" {
  description = "ID of created VPC"
  default = "subnet-0f8ae5064737cab94"
}
