resource "kubernetes_namespace" "namespace" {
  metadata {
    name = var.namespace
    labels = var.labels
  }
  depends_on = [ var.namespace_depends_on ]
}

resource "kubernetes_deployment" "deploy" {
  metadata {
    name = "${var.deployment_name}-${terraform.workspace}"
    namespace = kubernetes_namespace.namespace.metadata[0].name
    labels = var.labels
  }

  spec {
    replicas = var.replicas
    
    selector {
      match_labels = var.labels
    }

    template {
      metadata {
        labels = var.labels
      }

      spec {
        container {
          image = "symefa/datasaur-symefa:latest"
          name  = "komodo"
          port {
              name = "komodo"
              container_port = 3000
          }
          
        }
        }
      }
    }
  }

resource "kubernetes_service" "komodo" {
  metadata {
    name = "${var.deployment_name}-service"
    namespace = kubernetes_namespace.namespace.metadata[0].name
    /*annotations = {
      "service.beta.kubernetes.io/aws-load-balancer-type" = "nlb-ip"
    }*/
    labels = var.labels
  }
  spec {
    selector = var.labels
    type  = "NodePort"
    port {
      port = 80
      target_port = 3000
      protocol = "TCP"
    }
  }
  depends_on = [ kubernetes_deployment.deploy ]
}

resource "kubernetes_ingress" "komodo" {
  metadata {
    name      = "${var.deployment_name}-ingress"
    namespace = kubernetes_namespace.namespace.metadata[0].name
    annotations = {
      "kubernetes.io/ingress.class"           = "alb"
      "alb.ingress.kubernetes.io/scheme"      = "internet-facing"
      "alb.ingress.kubernetes.io/target-type" = "ip"
    }
    labels = var.labels
  }

  spec {
    backend {
      service_name = kubernetes_service.komodo.metadata[0].name
      service_port = kubernetes_service.komodo.spec[0].port[0].port
    }
    rule {
      http {
        path {
          path = "/*"
          backend {
            service_name = kubernetes_service.komodo.metadata[0].name
            service_port = kubernetes_service.komodo.spec[0].port[0].port
          }
        }
      }
    }
  }
  wait_for_load_balancer = true
  depends_on = [ kubernetes_service.komodo, helm_release.using_iamserviceaccount ]
}