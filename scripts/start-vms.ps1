# local
az vm start --resource-group devstarops-local-rg --name local-dso-frontdoor-vm --no-wait
az vm start --resource-group devstarops-local-rg --name local-dso-app1-vm --no-wait
# test
az vm start --resource-group devstarops-test-rg --name test-dso-frontdoor-vm --no-wait
az vm start --resource-group devstarops-test-rg --name test-dso-app1-vm --no-wait
