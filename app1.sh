#! /bin/bash

while [ "$(hostname -I)" = "" ]; do
  echo -e "\e[1A\e[KNo network: $(date)"
  sleep 1
done
echo "I have network";

resource_group_name=${resource_group_name}
storage_account_name=${storage_account_name}
github_username=${github_username}
github_token=${github_token}

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
podman login ghcr.io --tls-verify --username $github_username --password $github_token

# profile
sudo mkdir /var/profile/
sudo touch /var/profile/error.log
sudo touch /var/profile/access.log
sudo az storage blob directory download --container "profile" --account-name $storage_account_name --source-path "*" --destination-path "/var/profile/" --recursive
sudo podman run -p 8100:80 --name profile --restart unless-stopped --replace --tls-verify --pull always -d -v /var/profile/nginx.conf:/etc/nginx/nginx.conf -v /var/profile/error.log:/var/log/nginx/error.log -v /var/profile/access.log:/var/log/nginx/access.log -v /var/profile/:/var/profile/ ghcr.io/devstarops/devstarops-profile:main

# blog
sudo mkdir /var/blog/
sudo touch /var/blog/error.log
sudo touch /var/blog/access.log
sudo az storage blob directory download --container "blog" --account-name $storage_account_name --source-path "*" --destination-path "/var/blog/" --recursive
sudo podman run -p 8101:5000 --name blog --restart unless-stopped --replace --tls-verify --pull always -d -v /var/blog/error.log:/var/log/nginx/error.log -v /var/blog/access.log:/var/log/nginx/access.log -v /var/blog/:/var/blog/ ghcr.io/devstarops/blog:main

# Debug Things
# systemctl status nginx
# cat /etc/apt/sources.list
# cat /var/log/cloud-init-output.log
