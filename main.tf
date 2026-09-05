terraform{
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 5.0"
        }
    }
}
provider "aws" {
    region = var.region
}

module "vpc"{
    source = "terraform-aws-modules/vpc/aws"
    version = "5.1.2"

    name="todo-vpc"
    cidr=var.cidr

    azs = ["${var.region}a", "${var.region}b"]
    public_subnets = var.public_subnets

    enable_nat_gateway = false
    enable_dns_hostnames = true
    map_public_ip_on_launch = true


    public_subnet_tags = {
        "kubernetes.io/role/elb" = 1
    }
}

module "eks" {
    source = "terraform-aws-modules/eks/aws"
    version = "20.8.0"

    cluster_name    = var.cluster_name
    cluster_version = "1.33"
    cluster_ip_family = "ipv4"
    vpc_id          = module.vpc.vpc_id
    subnet_ids     = module.vpc.public_subnets
    cluster_endpoint_public_access  = true

    eks_managed_node_groups = {
        default = {
            instance_types = ["t3.small"]
            iam_role_attach_cni_policy = true
            min_size       = 1
            max_size       = 2
            desired_size   = 2        
        }
    }

    enable_cluster_creator_admin_permissions = true
}
