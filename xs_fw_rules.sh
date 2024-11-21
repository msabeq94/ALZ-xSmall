#!/bin/bash
mgmtSubID='24624965-8c6d-4d1a-b50d-a4970f5b21df'
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
        read -p "Enter your choice (1 or 2): " choiceNTaction
        case $choiceNTaction in
            1) NTaction="Allow"; break ;;
            2) NTaction="Deny"; break ;;
            *) echo "Invalid choice. Please enter 1 or 2." ;;
        esac
    done

    echo "Enter the Rule Name:"
    read NetworkRuleName

    while true; do
        echo "Select the protocol: (1) Any, (2) ICMP, (3) TCP, (4) UDP" 
        read -p "Enter your choice : " choiceNTprotocol
        case $choiceNTprotocol in
            1) NTprotocol="Any"; break ;;
            2) NTprotocol="ICMP"; break ;;
            3) NTprotocol="TCP"; break ;;
            4) NTprotocol="UDP"; break ;;
            *) echo "Invalid protocol. Please enter 1, 2, 3 or 4." ;;
        esac
    done

    echo "Enter the source address:"    
    read NetworksourceAddress
  

    echo "Enter the destination address:"
    read NetworkdestinationAddress
   
    echo "Enter the destination port:"
    read NetworkdestinationPort
    


    # Run the Azure CLI command
    az network firewall network-rule create \
        --collection-name $NetworkCollectionName \
        --firewall-name $firewallName \
        --name $NetworkRuleName \
        --protocols $NTprotocol \
        --resource-group $rg \
        --source-addresses "$NetworksourceAddress" \
        --destination-addresses "$NetworkdestinationAddress" \
        --destination-ports "$NetworkdestinationPort" \
        --action $NTaction \
        --priority $NetworkCollectionPriority
    ;;

  3)
    echo "You selected Application Rule Collection."
    echo "Enter the Application Rule Collection name:"
    read ApplicationCollectionName

    echo "Enter the Application Rule Collection priority (100-64999):"
    read ApplicationCollectionPriority

    while true; do
        echo "Select the action: (1) Allow, (2) Deny"
        read -p "Enter your choice (1 or 2): " choiceAPaction
        case $choiceAPaction in
            1) APaction="Allow"; break ;;
            2) APaction="Deny"; break ;;
            *) echo "Invalid choice. Please enter 1 or 2." ;;
        esac
    done

    echo "Enter the Rule Name:"
    read ApplicationRuleName

    # while true; do
    #     echo "Select the protocol: (1) http:80, (2) https:443 " 
    #     read -p "Enter your choice : " choiceAPProtocol
    #     case $choiceAPProtocol in
    #     1) APprotocol="http:80"; break ;;
    #     2) APprotocol="https:443"; break ;; 
    #     *) echo "Invalid protocol. Please enter 1, or 2" ;;
    #     esac
    # done

    #  echo "Select the protocol:"
    # read   APprotocol

    echo "Enter the source address:"
    read ApplicationSourceAddress

    echo "Enter the target FQDNs:"
    read ApplicationTargetFQDNs
    
    az network firewall application-rule create \
    --collection-name $ApplicationCollectionName \
    --firewall-name $firewallName \
    --name $ApplicationRuleName \
    --protocols 'http:80' \
    --resource-group $rg \
    --source-addresses "$ApplicationSourceAddress" \
    --target-fqdns "$ApplicationTargetFQDNs" \
    --action $APaction \
    --priority $ApplicationCollectionPriority
    ;;

  *)
    echo "Invalid choice. Please enter 1, 2, or 3."
    ;;
esac


##


# # #network-rule
#  az network firewall network-rule create  --collection-name "DefweererwewausdsdsdltCollection" --firewall-name $firewallName --name "AllowewwAll" --protocols "Any" --resource-group $rg   --source-addresses "*"  --destination-addresses "*" --destination-ports "*" --action "Allow" --priority 3550 

# # #nat-rule
# az network firewall nat-rule create --collection-name "DefaultCollectionSSS" --firewall-name $firewallName --name "AllowAll" --protocols "Any" --resource-group $rg --source-addresses "*" --destination-addresses $fwIPAddress --destination-ports "40" --action "Dnat" --priority 200 --translated-port 80 --translated-address "10.1.1.0"

# # #application-rule
# # #az network firewall application-rule create --collection-name "DefaultCollection" --firewall-name $firewallName --name "AllowAll" --protocols "Any" --resource-group $rg --source-addresses "*" --fqdn-tags "AzureBackup" --action "Allow" --priority 200
# az network firewall application-rule create --collection-name "DefaultCollection" --firewall-name $firewallName --name "AllowAll" --protocols "http" --resource-group $rg --source-addresses "*" --target-fqdns "www.alz.com" --action "Allow" --priority 200




