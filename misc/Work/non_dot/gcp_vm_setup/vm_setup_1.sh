sudo apt update
sudo apt -y install tmux ffmpeg fuse3 rsync unzip
sudo apt -y install libavif-dev libheif-dev
# curl -LsSf https://astral.sh/uv/install.sh | sh       # installs to $HOME/.local/bin (inaccessible to other users, hence use pipx --global)

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

cd ~/installs
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage
chmod u+x nvim-linux-x86_64.appimage
ln -s ~/installs/nvim-linux-x86_64.appimage ~/.local/bin/nvim

cd
sudo apt -y install pipx
pipx ensurepath
printf '\n# pipx autocompletions\neval "$(register-python-argcomplete pipx)"\n' >> ~/.bashrc

sudo PIPX_HOME=/opt/pipx PIPX_BIN_DIR=/usr/local/bin pipx install uv --force

source ~/.bashrc

uv tool install ruff
uv tool install ty

echo "Run exec \$SHELL"

# Then rsync nvim config and .tmux.conf from local
