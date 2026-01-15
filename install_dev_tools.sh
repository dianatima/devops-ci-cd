#!/usr/bin/env bash
set -e

echo "Update packages"
apt update -y

# Docker
if ! command -v docker >/dev/null 2>&1; then
  echo "-- Install Docker"
  apt install -y docker.io
else
  echo "Docker already installed"
fi

# Docker Compose
# Modern compose: "docker compose" plugin
if ! command -v docker-compose >/dev/null 2>&1; then
  echo "-- Install Docker Compose"
  apt install -y docker-compose
else
  echo "Docker Compose already installed"
fi

# Python 3.9+
if ! command -v python3 >/dev/null 2>&1; then
  echo "-- Install Python3"
  apt install -y python3
else
  echo "Python already installed: $(python3 --version)"
fi

# pip
if ! command -v pip3 >/dev/null 2>&1; then
  echo "-- Install pip "
  apt install -y python3-pip
else
  echo "pip already installed: $(pip3 --version | head -n1)"
fi

#  Django
if python3 -c "import django" >/dev/null 2>&1; then
  echo "Django already installed: $(python3 -c 'import django; print(django.get_version())')"
else
  echo "-- Install Django"
  pip3 install --user django
fi

echo "-- Versions"
docker --version || true
docker-compose --version || true
python3 --version || true
python3 -c "import django; print('Django', django.get_version())" || true

echo "DONE"
