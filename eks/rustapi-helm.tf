# rustapi helm 배포
resource "helm_release" "rustapi" {
  name       = "rustapi"
  namespace  = "default"
  chart      = "../rustapi-helm-chart"
  version    = "1.0.0"
}