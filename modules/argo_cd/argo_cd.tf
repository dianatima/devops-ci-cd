resource "kubernetes_namespace" "ns" {
  metadata { name = var.namespace }
}

resource "helm_release" "argocd" {
  name       = var.release_name
  repository = "https://argoproj.github.io/argo-helm"
  chart      = var.chart
  version    = var.chart_version
  namespace  = kubernetes_namespace.ns.metadata[0].name
  values     = [file("${path.module}/values.yaml")]

  depends_on = [kubernetes_namespace.ns]
}

# Власний helm-чарт, що створює Argo Application + (за потреби) Git repo secret
resource "helm_release" "argocd_apps" {
  name       = "${var.release_name}-apps"
  chart      = "${path.module}/charts"
  namespace  = kubernetes_namespace.ns.metadata[0].name

  set {
    name  = "applications[0].name"
    value = var.app_name
  }
  set { name = "applications[0].namespace"       value = var.app_namespace }
  set { name = "applications[0].repoURL"         value = var.helm_repo_url }
  set { name = "applications[0].targetRevision"  value = var.helm_repo_branch }
  set { name = "applications[0].path"            value = var.helm_chart_path }
  set { name = "applications[0].releaseName"     value = var.helm_release_name }

  depends_on = [helm_release.argocd]
}