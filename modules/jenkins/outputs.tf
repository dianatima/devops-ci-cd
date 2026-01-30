output "url" {
  value = "http://${helm_release.jenkins.name}.${kubernetes_namespace.ns.metadata[0].name}.svc.cluster.local"
}

output "admin_password" {
  value     = try(helm_release.jenkins.metadata[0].values["controller"]["admin"]["password"], "<see Kubernetes secret: jenkins in namespace>")
  sensitive = true
}