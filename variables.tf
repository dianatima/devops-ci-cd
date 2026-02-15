# EKS
variable "cluster_name"       { type = string default = "final-project-eks" }
variable "kubernetes_version" { type = string default = "1.29" }
variable "node_group_name"    { type = string default = "final-project-ng" }
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

# RDS/Aurora
variable "db_name"        { type = string default = "appdb" }
variable "use_aurora"     { type = bool   default = true }
variable "engine_family"  { type = string default = "postgres" }
variable "rds_engine"     { type = string default = "postgres" }
variable "rds_engine_version" { type = string default = "16.3" }
variable "aurora_engine"        { type = string default = "aurora-postgresql" }
variable "aurora_engine_version"{ type = string default = "16.1" }
variable "db_instance_class"    { type = string default = "db.t3.medium" }
variable "db_allocated_storage" { type = number default = 20 }
variable "db_storage_type"      { type = string default = "gp3" }
variable "db_multi_az"          { type = bool   default = false }
variable "db_port"              { type = number default = 5432 }      # 3306 for MySQL
variable "db_allowed_cidrs"     { type = list(string) default = ["10.0.0.0/16"] }
variable "db_publicly_accessible"{ type = bool   default = false }
variable "db_backup_days"       { type = number default = 7 }
variable "db_deletion_protection"{ type = bool   default = false }
variable "db_master_username"   { type = string default = "appuser" }
variable "db_master_password"   { type = string default = "ChangePassword123!" }

# Monitoring (kube-prometheus-stack)
variable "monitoring_namespace" { type = string default = "monitoring" }
variable "kps_release"          { type = string default = "kube-prometheus" }
variable "kps_chart"            { type = string default = "prometheus-community/kube-prometheus-stack" }
variable "kps_chart_ver"        { type = string default = "58.3.2" }

# ArgoCD додаток
variable "helm_repo_url"     { type = string default = "https://github.com/dianatima/devops-ci-cd.git" }
variable "helm_repo_branch"  { type = string default = "final-project" }
variable "helm_chart_path"   { type = string default = "charts/django-app" }
variable "helm_release_name" { type = string default = "django" }