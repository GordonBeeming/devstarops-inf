cd ..
terraform init -reconfigure -var-file="envs/local.tfvars" -backend-config="envs/local.tfbackend" -upgrade %*
cd scripts