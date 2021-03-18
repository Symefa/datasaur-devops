provider "aws" {
    region  = "ap-southeast-1"
}

module "network" {
    source              = "./modules/network"
    vpc_name            = var.vpc_name
    vpc_cidr            = var.vpc_cidr
    eks_cluster_name    = var.eks_cluster_name
    cidr_block_igw      = var.cidr_block_igw
}

module "eks_cluster" {
  source              = "./modules/eks/eks_cluster"
  cluster_name        = var.eks_cluster_name
  public_subnets      = module.network.aws_subnets_public
  private_subnets     = module.network.aws_subnets_private
} 

module "eks_node_group" {
  source            = "./modules/eks/eks_node_group"
  eks_cluster_name  = module.eks_cluster.cluster_name
  node_group_name   = var.node_group_name
  subnet_ids        = [ module.network.aws_subnets_private[0], module.network.aws_subnets_private[1] ]
  instance_types    = var.ng_instance_types
  disk_size         = var.disk_size
  desired_nodes     = var.desired_nodes
  max_nodes         = var.max_nodes
  min_nodes         = var.min_nodes
}

module "fargate" {
  source                  = "./modules/eks/fargate"
  eks_cluster_name        = module.eks_cluster.cluster_name
  fargate_profile_name    = var.fargate_profile_name
  subnet_ids              = module.network.aws_subnets_private
  kubernetes_namespace    = var.kubernetes_namespace
}

module "kubernetes" {
  source                = "./modules/kubernetes"
  region                = var.region
  vpc_id                = module.network.vpc_id
  vpc_cidr              = var.vpc_cidr
  eks_cluster_name      = module.eks_cluster.cluster_name
  eks_cluster_endpoint  = module.eks_cluster.endpoint
  eks_oidc_url          = module.eks_cluster.oidc_url
  eks_ca_certificate    = module.eks_cluster.ca_certificate
  namespace             = var.kubernetes_namespace
  replicas              = var.deployment_replicas
  deployment_name       = var.deployment_name
  labels                = var.app_labels
  acm_certificate       = module.route53.acm_certificate
  domain_name           = "komodo.${var.domain_name}"
  namespace_depends_on  = [ module.fargate.id , module.eks_node_group.id ]
}

module "route53" {
  source                = "./modules/dns"
  domain                = var.domain_name
  record_elb_address    = [module.kubernetes.load_balancer_hostname]
}

module "monitoring" {
  source  = "./modules/monitoring"
  eks_cluster_name      = module.eks_cluster.cluster_name
  eks_cluster_endpoint  = module.eks_cluster.endpoint
  eks_ca_certificate    = module.eks_cluster.ca_certificate
  labels                = var.app_labels
  namespace_depends_on  = [module.fargate.id]
  grafana_password      = var.grafana_password
}