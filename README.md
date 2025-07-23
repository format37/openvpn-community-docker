# openvpn-community-docker
Free openvpn for unlimited count of users in docker

### Machine preparation
You need ubuntu machine with fixed ext ip and docker installed  
For example: GCP e2-small (2 vCPUs, 2 GB Memory)
### Docker installation
```
sudo apt update
sudo apt install ca-certificates curl gnupg lsb-release -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
docker --version
sudo systemctl status docker
# Optional: Add your user to the docker group (log out/in or reboot required)
sudo usermod -aG docker $USER
```
### Installation
```
git clone https://github.com/format37/openvpn-community-docker.git
cd openvpn-community-docker
```

* Replace YOUR_SERVER_IP by your ext ip  
* Remember passphrase, u would be asked this passphrase every new key generation  
```
# Create Docker volume for OpenVPN data
sudo docker volume create ovpn-data

# Generate configuration and certificates (replace YOUR_SERVER_IP or domain)
sudo docker run -v ovpn-data:/etc/openvpn --rm kylemanna/openvpn ovpn_genconfig -u udp://YOUR_SERVER_IP

# Initialize the PKI and generate server certificates
sudo docker run -v ovpn-data:/etc/openvpn --rm -it kylemanna/openvpn ovpn_initpki

# Start the OpenVPN container in detached mode
sudo docker run -v ovpn-data:/etc/openvpn -d --cap-add=NET_ADMIN -p 1194:1194/udp --name openvpn kylemanna/openvpn
```

### Firewall configuration
VPC firewall rules -> add rule -> udp: 1194 incoming

### Key generation
Generate key
```
./generate.sh example_user
```
Send to telegram
(token and username need to be defined)
```
./send.sh example_user.ovpn
```
You can merge these scripts for convenience