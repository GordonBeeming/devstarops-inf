# local
az vm stop --resource-group devstarops-local-rg --name local-dso-frontdoor-vm --no-wait
az vm stop --resource-group devstarops-local-rg --name local-dso-app1-vm --no-wait
# test
az vm stop --resource-group devstarops-test-rg --name test-dso-frontdoor-vm --no-wait
az vm stop --resource-group devstarops-test-rg --name test-dso-app1-vm --no-wait
