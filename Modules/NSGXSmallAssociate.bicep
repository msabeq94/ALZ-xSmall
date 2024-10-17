param VnetName string
param VnetSubnetName string
param NSGID string


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
    networkSecurityGroup: {
      id:  NSGID
    }
  }

}



