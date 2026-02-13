# EKS
variable "cluster_name"       { type = string default = "lesson-8-9-eks" }
variable "kubernetes_version" { type = string default = "1.29" }
variable "node_group_name"    { type = string default = "lesson-8-9-ng" }
variable "instance_types"     { type = list(string) default = ["t3.medium"] }
variable "desired_size"       { type = number default = 2 }
variable "min_size"           { type = number default = 2 }
variable "max_size"           { type = number default = 4 }

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


# RDS
variable "db_name" { type = string, default = "appdb" }