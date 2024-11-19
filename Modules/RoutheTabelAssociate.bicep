param VnetName string
param VnetSubnetName string
// param routeTablesID string
param SUBaddressPrefix string


resource vnet 'Microsoft.Network/virtualNetworks@2023-09-01' existing = {
  name: VnetName
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2023-09-01' existing = {
  name: VnetSubnetName
  parent: vnet
}



resource subnetNSG 'Microsoft.Network/virtualNetworks/subnets@2023-09-01' = {
  name: subnet.name
  parent: vnet
  properties: {
    addressPrefix: SUBaddressPrefix
    routeTable: {
      id: '/subscriptions/102170e2-9371-4b66-95de-d4530f8bf56e/resourceGroups/CentralNetworkHub/providers/Microsoft.Network/routeTables/vf-core-alz-rt'
    }
  }

}





