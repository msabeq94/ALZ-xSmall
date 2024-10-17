param VnetProductionName string
param VnetProductionSubnetName string
param VnetDevelopmentName string
param VnetDevelopmentSubnetName string
param NSGID string


resource vnetPRO 'Microsoft.Network/virtualNetworks@2023-09-01' existing = {
  name: VnetProductionName
}

resource subnetPRO 'Microsoft.Network/virtualNetworks/subnets@2023-09-01' existing = {
  name: VnetProductionSubnetName
  parent: vnetPRO
}

resource vnetDEV 'Microsoft.Network/virtualNetworks@2023-09-01' existing = {
  name: VnetDevelopmentName
}

resource subnetDEV 'Microsoft.Network/virtualNetworks/subnets@2023-09-01' existing = {
  name: VnetDevelopmentSubnetName
  parent: vnetDEV
}

resource subnetNSGPRO 'Microsoft.Network/virtualNetworks/subnets@2023-09-01' = {
  name: subnetPRO.name
  parent: vnetPRO
  properties: {
    networkSecurityGroup: {
      id:  NSGID
    }
  }

}

resource subnetNSGDEV 'Microsoft.Network/virtualNetworks/subnets@2023-09-01' = {
  name: subnetDEV.name
  parent: vnetDEV
  properties: {
    networkSecurityGroup: {
      id:  NSGID
    }
  }
 
}

