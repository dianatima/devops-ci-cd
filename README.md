Terraform AWS Infrastructure — lesson-5

Навчальний проєкт з Terraform для створення базової AWS-інфраструктури з використанням модульного підходу.

Проєкт демонструє:
- роботу з Terraform backend (S3 + DynamoDB),
- побудову мережевої інфраструктури (VPC),
- створення ECR репозиторію для Docker-образів.

СТРУКТУРА ПРОЄКТУ:

- main.tf — підключення та конфігурація всіх модулів
- backend.tf — налаштування збереження Terraform state у S3 з блокуванням через DynamoDB
- outputs.tf — загальні вихідні дані з усіх модулів

МОДУЛІ:

- modules/s3-backend — створення S3-бакета для state-файлів та DynamoDB таблиці для lock-механізму
- modules/vpc — створення VPC з публічними і приватними підмережами та маршрутизацією
- modules/ecr — створення ECR репозиторію з увімкненим скануванням образів

ЗАПУСК ПРОЄКТУ:

Для ініціалізації та керування інфраструктурою використовуйте стандартні команди Terraform:

terraform init
terraform plan
terraform apply
terraform destroy
