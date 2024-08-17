# prometheus, grafana helm 배포
resource "helm_release" "kube_prometheus_stack" {
  name       = "prometheus"
  namespace  = "monitoring"
  chart      = "kube-prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  version    = "50.1.0"

  # grafana ingress 설정
  values = [
    file("grafana-ingress.yaml")     
  ]
}