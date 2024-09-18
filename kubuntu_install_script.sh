#!/bin/bash

# Actualizar e instalar dependencias necesarias
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl gnome-terminal apt-transport-https ca-certificates software-properties-common

# Instalar Visual Studio Code
echo "Instalando Visual Studio Code..."
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
sudo sh -c 'echo "deb [arch=arm64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg
sudo apt update
sudo apt install -y code

# Instalar Slack
echo "Instalando Slack..."
sudo snap install slack --classic

# Instalar NVM (Node Version Manager)
echo "Instalando NVM..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash

# Actualizar el path para NVM
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # Esto carga nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # Esto carga nvm bash_completion

# Instalar la última versión LTS de Node.js
nvm install --lts

# Instalar Google Chrome
echo "Instalando Google Chrome..."
wget https://dl.google.com/linux/direct/google-chrome-stable_current_arm64.deb
sudo apt install -y ./google-chrome-stable_current_arm64.deb
rm google-chrome-stable_current_arm64.deb

# Instalar Android Studio
echo "Instalando Android Studio..."
sudo snap install android-studio --classic

# Instalar Docker Desktop
echo "Instalando Docker Desktop..."

# Agregar Docker GPG key y repositorio
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=arm64 signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Instalar dependencias de Docker
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Descargar Docker Desktop para ARM64
wget https://desktop.docker.com/linux/main/arm64/docker-desktop-arm64.deb -O docker-desktop.deb

# Instalar Docker Desktop
sudo apt install -y ./docker-desktop.deb
rm docker-desktop.deb

# Configuración post-instalación de Docker Desktop
sudo sysctl -w kernel.apparmor_restrict_unprivileged_userns=0
systemctl --user enable docker-desktop
systemctl --user start docker-desktop

echo "Instalación completada. Reinicia el equipo para aplicar los cambios."
