variable "eks_cluster_name" {
    description = "Name of the EKS Cluster"
}

variable "eks_cluster_endpoint" {
    type = string
    description = "EKS Cluster Endpoint"
}

variable "eks_ca_certificate" {
    type = string
    description = "EKS Cluster CA Certificate"
}


variable "namespace" {
  type = string
  default = "monitoring"
}

variable "grafana_password" {
  type = string
}

variable "labels" {
    type = map
    description = "List of the labels for Deployment"
}

variable "namespace_depends_on" {
  type    = any
  default = null
}