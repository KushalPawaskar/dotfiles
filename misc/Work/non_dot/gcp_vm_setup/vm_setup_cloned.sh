#!/usr/bin/env bash

# Copy data from existing location
cd
sudo cp -r /home/pawaskarsushil/dreamlens-ds .
sudo cp -r /home/pawaskarsushil/data .

# Install uv
curl -LsSf https://astral.sh/uv/install.sh | sh
source ~/.bashrc

# Create a virtual environment
mkdir venvs
cd venvs
uv venv --python 3.12 dreamplay
cd

# Activate the virtual environment
source ~/venvs/dreamplay/bin/activate

# Fix permission issues
sudo chown $USER ~/dreamlens-ds/ -R

# Install requirements
cd ~/dreamlens-ds
uv pip install -r light_requirements.txt

# Setup google-cloud-sdk in home directory for automatic rally detection (optional for now, since we will be using manual annotated rallies.json)
chmod +x engines/event/setup_rally.sh
./engines/event/setup_rally.sh
