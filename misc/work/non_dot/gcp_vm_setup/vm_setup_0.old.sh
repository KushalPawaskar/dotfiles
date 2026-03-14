lspci | grep -i nvidia
hostnamectl
sudo apt update
sudo apt -y upgrade
sudo apt -y install build-essential
cd
mkdir installs
cd installs
wget https://developer.download.nvidia.com/compute/cuda/13.0.2/local_installers/cuda-repo-debian12-13-0-local_13.0.2-580.95.05-1_amd64.deb
sudo dpkg -i cuda-repo-debian12-13-0-local_13.0.2-580.95.05-1_amd64.deb
sudo cp /var/cuda-repo-debian12-13-0-local/cuda-*-keyring.gpg /usr/share/keyrings/
sudo apt-get update
sudo apt-get -y install cuda-toolkit-13-0
sudo apt-get -y install linux-headers-$(uname -r)
sudo apt-get install -y cuda-drivers
echo "export PATH=${PATH}:/usr/local/cuda-13.0/bin" >> ~/.bashrc
sudo reboot
