az login
az account set --subscription "8bec5d67-8e91-466a-8d6b-1bbfa4f642df"
az account show

# local
az vm deallocate --resource-group devstarops-local-rg --name local-dso-frontdoor-vm --no-wait
az vm deallocate --resource-group devstarops-local-rg --name local-dso-app1-vm --no-wait
# test
az vm deallocate --resource-group devstarops-test-rg --name test-dso-frontdoor-vm --no-wait
az vm deallocate --resource-group devstarops-test-rg --name test-dso-app1-vm --no-wait

. .\set-local-envs.ps1