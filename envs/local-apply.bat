cd ..
terraform apply -auto-approve -json "envs/local.tfplan"
cd envs