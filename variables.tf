# Jenkins
variable "jenkins_namespace"   { type = string default = "jenkins" }
variable "jenkins_release"     { type = string default = "jenkins" }
variable "jenkins_chart"       { type = string default = "jenkinsci/jenkins" }
variable "jenkins_chart_ver"   { type = string default = "5.6.2" } 


# Argo CD
variable "argocd_namespace"  { type = string default = "argocd" }
variable "argocd_release"    { type = string default = "argo-cd" }
variable "argocd_chart"      { type = string default = "argo/argo-cd" }
variable "argocd_chart_ver"  { type = string default = "6.7.8" } 

variable "kubeconfig_path" { type = string default = "~/.kube/config" }