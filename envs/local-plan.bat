cd ..
terraform plan -var-file="envs/local.tfvars" -out="envs/local.tfplan"
cd envs