Terraform AWS Infrastructure — lesson-8-9 (EKS + ECR + CI/CD)

Навчальний проєкт з Terraform та CI/CD для розгортання Django-застосунку в Amazon EKS з використанням ECR, Helm, Jenkins та Argo CD.
Проєкт демонструє повний шлях від інфраструктури до автоматизованого деплою в Kubernetes.

Реалізовано:

Terraform:
- backend у S3 + DynamoDB (state + lock),
- PC з публічними та приватними підмережами,
- ECR для Docker-образів,
- EKS (Kubernetes cluster),
- становлення Jenkins та Argo CD через Helm.

Jenkins CI:
- збір Docker-образу Django,
- push образу в Amazon ECR,
- автоматичне оновлення values.yaml Helm-чарта (image tag),
- push змін у Git-репозиторій.

Helm:
- деплой Django-застосунку,
- Service типу LoadBalancer,
- ConfigMap для змінних середовища,
- HPA (Horizontal Pod Autoscaler).

Argo CD (GitOps):
- синхронізація кластера з Git-репозиторієм,
- автоматичний деплой після змін у Helm-чарті.


ЗАПУСК ПРОЕКТУ

1. Ініціалізація backend
backend.tf тимчасово закоментований
terraform init
terraform apply -target=module.s3_backend -auto-approve

Після створення S3 та DynamoDB — розкоментувати backend.tf і виконати:
terraform init -migrate-state

2. Розгортання інфраструктури
terraform apply -auto-approve

Будуть створені:
- VPC
- ECR
- EKS
- Jenkins
- Argo CD

3. Підключення до EKS
aws eks update-kubeconfig \
  --region us-west-2 \
  --name $(terraform output -raw eks_cluster_name)
kubectl get nodes


CI/CD логіка

Jenkins:
збирає Docker-образ Django,
пушить образ в ECR,
оновлює values.yaml Helm-чарта.

Argo CD:
відстежує зміни в Git,
автоматично синхронізує стан кластера.


Очищення ресурсів:
terraform destroy