output "url" {
  value = "http://${helm_release.argocd.name}.${kubernetes_namespace.ns.metadata[0].name}.svc.cluster.local"
}

output "admin_password" {
  value     = "<дізнайся з secret argocd-initial-admin-secret у namespace argocd>"
  sensitive = true
}