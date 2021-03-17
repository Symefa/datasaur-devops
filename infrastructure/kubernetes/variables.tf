variable "region" {
    type = string
    description = "AWS Region"
}

variable "vpc_id" {
    type = string
    description = "EKS Cluster VPC ID"
}

variable "vpc_cidr" {
    type = string
    description = "VPC CIDR Block"
}

variable "eks_cluster_name" {
    description = "Name of the EKS Cluster"
}

variable "deployment_name" {
    type = string
    description = "Name of the Deployment"
}

variable "namespace" {
    type = string
    description = "Name of the Namespace"
}

variable "replicas" {
    type = string
    description = "Number of replicas for the Deployment"
}

variable "labels" {
    type = map
    description = "List of the labels for Deployment"
}

variable "eks_cluster_endpoint" {
    type = string
    description = "EKS Cluster Endpoint"
}

variable "eks_oidc_url" {
    type = string
    description = "EKS Cluster OIDC Provider URL"
}

variable "eks_ca_certificate" {
    type = string
    description = "EKS Cluster CA Certificate"
}

variable "namespace_depends_on" {
  type    = any
  default = null
}