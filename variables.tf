variable "region"{
    description = "The AWS region to deploy resources"
    type        = string
    default     = "us-east-1"
}

variable "cluster_name" {
    description = "The name of the EKS cluster"
    type        = string
    default     = "todo-cluster"
}

variable "cidr" {
    description = "The CIDR block for the VPC"
    type        = string
    default     = "10.0.0.0/16"
}

variable "public_subnets" {
    description = "List of public subnets"
    type        = list(string)
    default     = ["10.0.1.0/24","10.0.2.0/24"]
}