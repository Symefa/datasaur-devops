data "template_file" "prometheus_values" {
  template = file("${path.module}/data/prometheus.yaml")
}

resource "helm_release" "prometheus" {
    chart      = "prometheus"
    name       = "prometheus"
    namespace  = var.namespace
    repository = "https://prometheus-community.github.io/helm-charts"

    values = [
      data.template_file.prometheus_values.rendered
    ]
     
}
