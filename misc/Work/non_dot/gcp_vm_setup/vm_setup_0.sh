lspci | grep -i nvidia
hostnamectl
sudo apt update

# --- CRITICAL FIX START ---
# Install headers for the CURRENT running kernel immediately
sudo apt -y install linux-headers-$(uname -r) build-essential

# PREVENT the kernel from upgrading during the next step
# This ensures your driver build matches the OS version
sudo apt-mark hold linux-image-$(uname -r) linux-headers-$(uname -r) linux-image-cloud-amd64 linux-headers-cloud-amd64
# --- CRITICAL FIX END ---

# 2. Safe Upgrade (Will upgrade security stuff, but skip the kernel)
sudo apt -y upgrade

# 3. CUDA Setup (Standard)
cd
mkdir -p installs
cd installs
wget https://developer.download.nvidia.com/compute/cuda/13.0.2/local_installers/cuda-repo-debian12-13-0-local_13.0.2-580.95.05-1_amd64.deb
sudo dpkg -i cuda-repo-debian12-13-0-local_13.0.2-580.95.05-1_amd64.deb
sudo cp /var/cuda-repo-debian12-13-0-local/cuda-*-keyring.gpg /usr/share/keyrings/
sudo apt-get update
sudo apt-get -y install cuda-toolkit-13-0

# 4. Install Drivers
# (Headers are already installed from step 1, but this doesn't hurt)
sudo apt-get install -y cuda-drivers

# 5. Environment Setup
#
# Commenting .bashrc line since it won't work for other users, instead adding a /etc line
# echo "export PATH=${PATH}:/usr/local/cuda-13.0/bin" >> ~/.bashrc
#
# Create a new file called 'cuda.sh' in the global profile directory
sudo bash -c 'cat <<EOF > /etc/profile.d/cuda.sh
# CUDA Environment Variables for all users
export PATH=\${PATH}:/usr/local/cuda-13.0/bin
export LD_LIBRARY_PATH=\${LD_LIBRARY_PATH}:/usr/local/cuda-13.0/lib64
EOF'

# 6. Apply Unattended Upgrades Blacklist to prevent kernel upgrade which breaks cuda drivers (kernel dependent, so need to be reinstalled for the correct kernel version)
# This ensures that even if you unhold the kernel later, the auto-updater won't touch it.
sudo bash -c 'cat <<EOF > /etc/apt/apt.conf.d/50unattended-upgrades-blacklist
Unattended-Upgrade::Package-Blacklist {
    "linux-image-.*";
    "linux-headers-.*";
    "linux-modules-.*";
    "linux-firmware";
};
EOF'

echo "Setup complete. Rebooting..."
sudo reboot
