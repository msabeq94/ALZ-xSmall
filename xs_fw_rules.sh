#!/bin/bash
mgmtSubID='102170e2-9371-4b66-95de-d4530f8bf56e'
firewallName='vf-core-alz-fw-eastus'

rg='vf-core-CentralHub-rg'
fwpublicipName='vf-core-alz-fw-ip'
fwIPAddress=$(az network public-ip show -g $rg -n $fwpublicipName --query ipAddress -o tsv)

# echo "Enter customer management subscription ID:"
# read mgmtSubID

# echo "Enter firewall name:"
# read firewallName



echo "Which firewall rule do you want to configure?"
echo "1) NAT Rule Collection"
echo "2) Network Rule Collection"
echo "3) Application Rule Collection"

read -p "Enter your choice (1, 2, or 3): " choice

case $choice in
  1)
    echo "You selected NAT Rule Collection."
    # Add your NAT Rule Collection configuration commands here
    ;;

  2)
    echo "You selected Network Rule Collection."

    echo "Enter the Network Rule Collection name:"
    read NetworkCollectionName

    echo "Enter the Network Rule Collection priority (100-64999):"
    read NetworkCollectionPriority

    while true; do
        echo "Select the action: (1) Allow, (2) Deny"
        read -p "Enter your choice (1 or 2): " choiceaction
        case $choiceaction in
            1) action="Allow"; break ;;
            2) action="Deny"; break ;;
            *) echo "Invalid choice. Please enter 1 or 2." ;;
        esac
    done

    echo "Enter the Rule Name:"
    read NetworkRuleName

    while true; do
        echo "Select the protocol: (1) Any, (2) TCP, (3) UDP"
        read -p "Enter your choice : " choiceProtocol
        case $choiceProtocol in
            1) protocol="Any"; break ;;
            2) protocol="TCP"; break ;;
            3) protocol="UDP"; break ;;
            *) echo "Invalid protocol. Please enter 1, 2, or 3." ;;
        esac
    done

    echo "Enter the source address:"    
    read NetworksourceAddress

    echo "Enter the destination address:"
    read NetworkdestinationAddress

    echo "Enter the destination port:"
    read NetworkdestinationPort

    # # Ensure firewallName and rg (resource group) are set
    # echo "Enter the Firewall Name:"
    # read firewallName

    # echo "Enter the Resource Group Name:"
    # read rg

    # Run the Azure CLI command
    az network firewall network-rule create \
        --collection-name $NetworkCollectionName \
        --firewall-name $firewallName \
        --name $NetworkRuleName \
        --protocols $protocol \
        --resource-group $rg \
        --source-addresses $NetworksourceAddress \
        --destination-addresses $NetworkdestinationAddress \
        --destination-ports $NetworkdestinationPort \
        --action $action \
        --priority $NetworkCollectionPriority
    ;;

  3)
    echo "You selected Application Rule Collection."
    # Add your Application Rule Collection configuration commands here
    # Example command:
    # az network firewall application-rule create --collection-name "DefaultCollection" --firewall-name $firewallName --name "AllowAll" --protocols "http=80" --resource-group $rg --source-addresses "*" --target-fqdns "www.alz.com" --action "Allow" --priority 200
    ;;

  *)
    echo "Invalid choice. Please enter 1, 2, or 3."
    ;;
esac


##


# # #network-rule
#  az network firewall network-rule create  --collection-name "DefweererwewausdsdsdltCollection" --firewall-name $firewallName --name "AllowewwAll" --protocols "Any" --resource-group $rg   --source-addresses "10.0.0.0/24"  --destination-addresses "10.1.0.0/24" --destination-ports "*" --action "Allow" --priority 3550 

# # #nat-rule
# az network firewall nat-rule create --collection-name "DefaultCollectionSSS" --firewall-name $firewallName --name "AllowAll" --protocols "Any" --resource-group $rg --source-addresses "*" --destination-addresses $fwIPAddress --destination-ports "40" --action "Dnat" --priority 200 --translated-port 80 --translated-address "10.1.1.0"

# # #application-rule
# # #az network firewall application-rule create --collection-name "DefaultCollection" --firewall-name $firewallName --name "AllowAll" --protocols "Any" --resource-group $rg --source-addresses "*" --fqdn-tags "AzureBackup" --action "Allow" --priority 200
# az network firewall application-rule create --collection-name "DefaultCollection" --firewall-name $firewallName --name "AllowAll" --protocols "http=80" --resource-group $rg --source-addresses "*" --target-fqdns "www.alz.com" --action "Allow" --priority 200




