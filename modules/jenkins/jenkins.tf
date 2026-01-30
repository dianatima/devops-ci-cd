resource "kubernetes_namespace" "ns" {
  metadata { name = var.namespace }
}

resource "helm_release" "jenkins" {
  name       = var.release_name
  repository = "https://charts.jenkins.io"
  chart      = var.chart
  version    = var.chart_version
  namespace  = kubernetes_namespace.ns.metadata[0].name

  values = [file("${path.module}/values.yaml")]

  depends_on = [kubernetes_namespace.ns]
}

resource "kubernetes_secret" "dummy" {
  metadata { name = "jenkins-admin-pass-ref" namespace = var.namespace }
  data = {}
  depends_on = [helm_release.jenkins]
}