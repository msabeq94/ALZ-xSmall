#!/bin/bash

rg='vf-core-CentralHub-rg'
echo "Enter customer management subscription ID:"
read mgmtSubID

echo "Enter firewall name:"
read firewallName

fwID=$(az network firewall show --name $firewallName --resource-group $rg --subscription $mgmtSubID --query id -o tsv)

az network firewall network-rule create  --collection-name "DefaultCollection" --firewall-name $firewallName --name "AllowAll" --protocols "Any" --resource-group $rg --rule-collection-group-name "NetworkRuleCollection" --rule-name "AllowAll" --source-addresses "*"  --destination-addresses "*" --destination-ports "*" --action "Allow" --priority 100 