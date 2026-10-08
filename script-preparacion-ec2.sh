#!/bin/bash
# script-preparacion-ec2.sh
# Instrucciones para preparar una instancia Ubuntu Server en AWS EC2 para el pipeline CI/CD

# 1. Configuración de Grupo de Seguridad (Security Group) en AWS EC2:
#    Asegúrate de tener un Security Group asociado a tu instancia EC2 que permita el tráfico entrante en los puertos:
#    - Puerto 22 (SSH): Para permitir la conexión de GitHub Actions. Es preferible limitar la IP de origen, o dejarlo abierto temporalmente para despliegue automatizado, pero por seguridad, usar un Security Group restringido.
#    - Puerto 80 (HTTP): Para permitir el tráfico web a la API REST.

# 2. Conectarse a la instancia por SSH (desde tu máquina local, la primera vez):
#    ssh -i "tu-llave.pem" ubuntu@IP_DE_TU_INSTANCIA

# 3. Ejecutar los siguientes comandos en la EC2 para instalar y configurar Docker:

# Actualizar el índice de paquetes
sudo apt-get update -y
sudo apt-get upgrade -y

# Instalar dependencias necesarias
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

# Añadir la llave GPG oficial de Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Configurar el repositorio estable de Docker
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Actualizar el índice nuevamente con los paquetes de Docker
sudo apt-get update -y

# Instalar Docker Engine
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# Asegurarse de que el servicio Docker se inicie al arrancar el sistema
sudo systemctl enable docker
sudo systemctl start docker

# Dar permisos al usuario de ubuntu para ejecutar Docker sin `sudo` (Opcional pero recomendado para pruebas locales, GitHub Actions usará sudo de todos modos)
sudo usermod -aG docker ubuntu

# Confirmar la instalación exitosa
sudo docker --version

# 4. Configurar secretos en el repositorio de GitHub:
# En tu repositorio de GitHub, ve a Settings -> Secrets and variables -> Actions
# Añade los siguientes secretos (New repository secret):
# - DOCKER_USERNAME: Tu nombre de usuario en Docker Hub
# - DOCKER_PAT: Tu Personal Access Token (PAT) de Docker Hub
# - EC2_HOST: La dirección IP pública o DNS de tu instancia EC2
# - EC2_USERNAME: ubuntu
# - EC2_SSH_KEY: El contenido completo del archivo .pem usado para conectarse a la EC2.

echo "Preparación completada. La EC2 ahora tiene Docker instalado y está lista para el pipeline."
