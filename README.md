Lesson 7 — Terraform + EKS + ECR + Helm

Навчальний проєкт з Terraform та Helm для розгортання Kubernetes-інфраструктури в AWS
та деплою Django-застосунку.

Реалізовано:

- Terraform backend (S3 + DynamoDB) для збереження state
- VPC з публічними та приватними підмережами
- ECR для зберігання Docker-образів
- EKS (Kubernetes cluster)** з node group
- Helm-chart для деплою Django-застосунку
- Service типу LoadBalancer**
- HPA (2–6 pod-ів, CPU > 70%)
- ConfigMap для змінних середовища

Опис модулів:

- s3-backend — S3 bucket та DynamoDB table для Terraform state
- vpc — мережа AWS (VPC, підмережі, маршрути)
- ecr — репозиторій для Docker-образів
- eks — Kubernetes-кластер та node group

Helm-chart `django-app` включає:

- Deployment Django-застосунку з образом з ECR
- Service типу LoadBalancer
- Horizontal Pod Autoscaler
- ConfigMap для змінних середовища

Основні параметри задаються у `values.yaml`.


Запуск інфраструктури:
terraform init
terraform plan
terraform apply

Видалення ресурсів:
terraform destroy
