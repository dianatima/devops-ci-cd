Final Project — DevOps CI/CD Pipeline (Terraform + EKS + Jenkins + Helm + Django)

Фінальний навчальний проєкт демонструє повний DevOps pipeline для розгортання Django-додатку в AWS з використанням Terraform, Kubernetes (EKS), Jenkins та Helm.

Проєкт реалізує:
- створення AWS інфраструктури через Terraform
- розгортання Kubernetes кластера (EKS)
- створення Docker registry (ECR)
- створення бази даних (RDS)
- CI/CD pipeline через Jenkins
- деплой Django додатку через Helm
- використання ArgoCD для CD
- збереження Terraform state в S3 + DynamoDB

АРХІТЕКТУРА

Pipeline складається з наступних компонентів:
GitHub → Jenkins → Docker → ECR → EKS → Helm → Django App
Infrastructure:
Terraform → AWS

- VPC
- EKS
- ECR
- RDS
- Jenkins
- ArgoCD

TERRAFORM МОДУЛІ

- modules/s3-backend (Створює S3 bucket і DynamoDB для Terraform state)
- modules/vpc (Створює VPC, public і private subnets)
- modules/ecr (Створює ECR repository для Docker images)
- modules/eks (Створює Kubernetes cluster (EKS))
- modules/rds (Створює PostgreSQL database)
- modules/jenkins (Створює Jenkins server)
- modules/argo_cd (Встановлює ArgoCD в Kubernetes)

DJANGO APPLICATION

Django folder містить:
- Dockerfile — для створення Docker image
- Jenkinsfile — pipeline для CI/CD
- docker-compose.yaml — локальний запуск

HELM DEPLOYMENT

Helm chart charts/django-app використовується для деплою Django в Kubernetes.
Створює:
- Deployment
- Service (LoadBalancer)
- ConfigMap

ЗАПУСК ПРОЄКТУ

Ініціалізація Terraform:
terraform init

Планування:
terraform plan

Розгортання:
terraform apply

Підключення до Kubernetes:
aws eks update-kubeconfig \
  --region us-west-2 \
  --name $(terraform output -raw eks_cluster_name)

Перевірка:
kubectl get nodes


JENKINS PIPELINE

Jenkins автоматично:
- будує Docker image
- пушить image в ECR
- деплоїть додаток через Helm

ВИДАЛЕННЯ ІНФРАСТРУКТУРИ
terraform destroy
