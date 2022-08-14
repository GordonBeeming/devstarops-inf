#! /bin/bash

while [ "$(hostname -I)" = "" ]; do
  echo -e "\e[1A\e[KNo network: $(date)"
  sleep 1
done
echo "I have network";

resource_group_name=${resource_group_name}
storage_account_name=${storage_account_name}
app1_ipaddress=${app1_ipaddress}
github_username=${github_username}
github_token=${github_token}

sudo -- sh -c -e "echo '$app1_ipaddress app1' >> /etc/hosts"

sudo apt-add-repository -y 'deb http://archive.ubuntu.com/ubuntu/ kinetic main restricted'
sudo apt-add-repository -y 'deb http://archive.ubuntu.com/ubuntu/ kinetic-updates main restricted'
sudo apt-add-repository -y 'deb http://archive.ubuntu.com/ubuntu/ kinetic universe'
sudo apt-add-repository -y 'deb http://archive.ubuntu.com/ubuntu/ kinetic-updates universe'
sudo apt-add-repository -y 'deb http://archive.ubuntu.com/ubuntu/ kinetic-backports main restricted universe multiverse'

sudo apt update

echo '* libraries/restart-without-asking boolean true' | sudo debconf-set-selections

sudo apt install -y podman

sudo apt-get update
sudo apt-get install -y ca-certificates curl apt-transport-https lsb-release gnupg
curl -sL https://packages.microsoft.com/keys/microsoft.asc |
    gpg --dearmor |
    sudo tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null
AZ_REPO="bullseye" # $(lsb_release -cs)
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" |
    sudo tee /etc/apt/sources.list.d/azure-cli.list
sudo apt-get update
sudo apt-get install -y azure-cli
az extension add --name storage-preview

az login --identity
podman login ghcr.io --tls-verify --username $github_username --password $github_password

# edge
sudo mkdir /var/edge/
sudo touch /var/edge/error.log
sudo touch /var/edge/access.log
sudo az storage blob directory download --container "frontdoor" --account-name $storage_account_name --source-path "*" --destination-path "/var/edge/" --recursive
# sudo az storage blob directory download --container "frontdoor" --account-name "dsolocalstorage" --source-path "*" --destination-path "/var/edge/" --recursive
sudo podman run -p 443:443 --name edge --restart unless-stopped --replace --tls-verify --pull always -d -v /var/edge/nginx.conf:/etc/nginx/nginx.conf -v /var/edge/error.log:/var/log/nginx/error.log -v /var/edge/access.log:/var/log/nginx/access.log -v /var/edge/:/var/edge/ ghcr.io/devstarops/devstarops-edge:main

# Debug Things
# systemctl status nginx
# cat /etc/apt/sources.list
# cat /var/log/cloud-init-output.log
