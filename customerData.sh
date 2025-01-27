#!/bin/bash

# Default Variables
dateYMD=$(date +%Y%m%dT%H%M%S%NZ)
MGID=alz
rg=rg-management
#NAME="alz-MgDeployment-${dateYMD}"
NAME="alz-MgDeployment"

#sed -i "s/PPCR/N/g" infra-as-code/bicep/modules/policy/assignments/alzDefaults/parameters/alzDefaultPolicyAssignments.parameters.all.json
# Prompt the user for deploymentType 
# echo "Enter the AZL deployment Type (XSmall,Small, Medium or Large)"
# read deploymentType
echo "Select the AZL deployment Type:"
options=("XSmall" "Small" "Medium" "Large")
select deploymentType in "${options[@]}"
do
    case $deploymentType in
        "XSmall")
            echo "You selected XSmall"
            break
            ;;
        "Small")
            echo "You selected Small"
            break
            ;;
        "Medium")
            echo "You selected Medium"
            break
            ;;
        "Large")
            echo "You selected Large"
            break
            ;;
        *)
            echo "Invalid option $REPLY"
            ;;
    esac
done

# Prompt the user for customer Location 
echo "Enter customer Location (Eg uksouth):"
read LOCATION
sed -i "s/customerLocation/${LOCATION}/g" Main.parameters.XSmall.json
# sed -i "s/customerLocation/${LOCATION}/g" ResourceGroup.parameters.XSmall.json
# sed -i "s/customerLocation/${LOCATION}/g" VNetCentralNetworkHub.parameters.XSmall.json
# sed -i "s/customerLocation/${LOCATION}/g" VNetProductionSpoke.parameters.XSmall.json
# sed -i "s/customerLocation/${LOCATION}/g" VNetDevelopmentSpoke.parameters.XSmall.json

# Feed files
#sed -i "s/customerLocation/${LOCATION}/g" infra-as-code/bicep/modules/logging/parameters/logging.parameters.all.json
#sed -i "s/customerLocation/${LOCATION}/g" infra-as-code/bicep/modules/policy/assignments/alzDefaults/parameters/alzDefaultPolicyAssignments.parameters.all.json

# Prompt the user for customer Name 
echo "Enter customer Name:"
read customerName

# Feed files

sed -i "s/customerName/${customerName}/g" managementGroups.parameters.XSmall.json

# Prompt the user for mgmt subscirption Id 
echo "Enter customer management subscription ID:"
read mgmtSubID

# Feed file
# sed -i "s/mgmtSubID/${mgmtSubID}/g" Main.parameters.XSmall.json
# sed -i "s/mgmtSubID/${mgmtSubID}/g" Modules/FWXSmall.bicep
sed -i "s/mgmtSubID/${mgmtSubID}/g" Modules/PolicyassignmentsXSmall.bicep
# RouteTableID="/subscriptions/${mgmtSubID}/resourceGroups/CentralNetworkHub/providers/Microsoft.Network/routeTables/ALZ-hub-routetable"
#sed -i "s/mgmtSubID/${mgmtSubID}/g" VNetCentralNetworkHub.parameters.XSmall.json

#Prompt the user for the securityEmail variable 
if [ "$deploymentType" != "XSmall" ]; then
    echo "Enter customer Security Email:"
    read securityEmail
fi

# Feed files
#sed -i "s/securityEmail/${securityEmail}/g" infra-as-code/bicep/modules/policy/assignments/alzDefaults/parameters/alzDefaultPolicyAssignments.parameters.all.json

# Output the entered variables
echo "#############################################################"
echo "#############################################################"
echo "The customer data is:"
echo "Location: $LOCATION"
echo "Management Sub ID: $mgmtSubID"
echo "Deployment Type: $deploymentType"
echo "Customer Name: $customerName"
if [ "$deploymentType" != "XSmall" ]; then
    echo "Security Email: $securityEmail"
fi



#az role assignment create --scope '/' --role 'Owner' --assignee-object-id "115c24f7-f361-46c4-826d-4cb4ac7b1f03" --assignee-principal-type 'ServicePrincipal'