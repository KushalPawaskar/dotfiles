#!/usr/bin/env bash

cd
sudo apt update
sudo apt -y install linux-headers-$(uname -r) build-essential
sudo apt -y upgrade

sudo apt -y install tmux ffmpeg fuse3 rsync unzip
sudo apt -y install libavif-dev libheif-dev

# Add ~/.local/bin to PATH if not already present
cat >> ~/.bashrc << 'EOF'

# Add ~/.local/bin to PATH if not already present
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    export PATH="$HOME/.local/bin:$PATH"
fi
EOF

sudo apt -y install locales
sudo sed -i 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
sudo locale-gen
sudo update-locale LANG=en_US.UTF-8
sudo sed -i '/LC_ALL/d' /etc/default/locale
if ! grep -q "export LANG=en_US.UTF-8" ~/.bashrc; then
    echo "" >> ~/.bashrc
    echo "# Locale settings" >> ~/.bashrc
    echo "export LANG=en_US.UTF-8" >> ~/.bashrc
fi

mkdir -p ~/installs
cd ~/installs
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage
chmod u+x nvim-linux-x86_64.appimage
mkdir -p ~/.local/bin
ln -s ~/installs/nvim-linux-x86_64.appimage ~/.local/bin/nvim

cd
sudo apt -y install pipx
pipx ensurepath
printf '\n# pipx autocompletions\neval "$(register-python-argcomplete pipx)"\n' >> ~/.bashrc

sudo PIPX_HOME=/opt/pipx PIPX_BIN_DIR=/usr/local/bin pipx install uv --force

source ~/.bashrc

uv tool install ruff
uv tool install ty

echo ""
echo "=== Setup Complete! ==="
echo ""
echo "Run: exec \$SHELL"
echo ""
echo "Then gcp-sync nvim config and .tmux.conf from local"
