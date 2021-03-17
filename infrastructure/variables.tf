variable "region" {
    type = string
    description = "AWS Region"
}

variable "vpc_name" {
    description = "Name of VPC"
}

variable "vpc_cidr" {
    description = "CIDR Block of the VPC"
}

variable "cidr_block_igw" {
    description = "CIDR Block for Internet and NAT Gateways"
}

variable "eks_cluster_name" {
    description = "Name of the EKS Cluster"
}

variable "node_group_name" {
    type = string
    description = "Name of the EKS Node Group"
}

variable "ng_instance_types" {
    type = list(string)
    description = "List of instance types associated with the EKS Node Group"
}

variable "disk_size" {
    description = "Disk Size for Worker Nodes in GiB"
}

variable "desired_nodes" {
    description = "Desired number of worker nodes"
}

variable "max_nodes" {
    description = "Maximum number of worker nodes"
}

variable "min_nodes" {
    description = "Minimum number of worker nodes"
}

variable "fargate_profile_name" {
    type = string
    description = "Name of the Fargate Profile"
}

variable "kubernetes_namespace" {
    type = string
    description = "Kubernetes namespace for selection"
}

variable "deployment_name" {
    type = string
    description = "Name of the Deployment"
}

variable "app_labels" {
    type = map
    description = "List of the labels for Deployment"
}

variable "deployment_replicas" {
    type = string
    description = "Number of replicas for the Deployment"
}