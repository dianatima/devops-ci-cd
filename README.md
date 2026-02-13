Lesson — Universal RDS Module (RDS / Aurora)

Навчальний проєкт з Terraform для створення універсального модуля бази даних, який може розгортати звичайний RDS instance або Aurora Cluster.
Модуль керується змінною use_aurora та підтримує гнучку конфігурацію через variables.

РЕАЛІЗОВАНО:
- Створює RDS instance або Aurora Cluster + writer
- Автоматично створює:
  DB Subnet Group
  Security Group
  Parameter Group
- Підтримує змінні:
  engine
  engine_version
  instance_class
  multi_az
  username / password
- Мінімальна логіка змін при перемиканні між RDS та Aurora

ПРИКЛАД ВИКОРИСТАННЯ:
Варіант 1 — Звичайний RDS:

module "rds" {
  source = "./modules/rds"

  use_aurora     = false
  engine         = "mysql"
  engine_version = "8.0"
  instance_class = "db.t3.micro"

  db_name  = "lesson_db"
  username = "admin"
  password = "password123"

  multi_az = false
}

Варіант 2 — Aurora Cluster:

module "rds" {
  source = "./modules/rds"

  use_aurora     = true
  engine         = "aurora-mysql"
  engine_version = "8.0.mysql_aurora.3.05.2"
  instance_class = "db.t3.medium"

  db_name  = "lesson_db"
  username = "admin"
  password = "password123"

  multi_az = true
}

ОПИС ОСНОВНИХ ЗМІННИХ:
| Змінна           | Опис                                        |
| ---------------- | ------------------------------------------- |
| use_aurora     | true → Aurora, false → RDS                  |
| engine         | Тип БД (mysql, postgres, aurora-mysql тощо) |
| engine_version | Версія engine                               |
| instance_class | Тип інстансу                                |
| multi_az       | Multi-AZ розгортання                        |
| db_name        | Назва бази даних                            |
| username       | Адміністратор                               |
| password       | Пароль                                      |


Як змінити тип БД:
- Змінити use_aurora
- За потреби змінити engine
- За потреби змінити engine_version


Запуск:
terraform init
terraform plan
terraform apply

Видалення ресурсів:
terraform destroy
