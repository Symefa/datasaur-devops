data "template_file" "grafana_values" {
	template = file("${path.module}/data/grafana.yaml")

  	vars = {
	  GRAFANA_SERVICE_ACCOUNT = "grafana"
	  GRAFANA_ADMIN_USER = "admin"
	  GRAFANA_ADMIN_PASSWORD = var.grafana_password
	  PROMETHEUS_SVC = "${helm_release.prometheus.name}-server"
	  NAMESPACE = var.namespace
	}
}

resource "helm_release" "grafana" {
  chart = "grafana"
  name = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  namespace = kubernetes_namespace.namespace.metadata[0].name

  values = [
  	data.template_file.grafana_values.rendered
  ]
}