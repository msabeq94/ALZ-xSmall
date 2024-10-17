param NSG_name string
param NSG_location string
param VnetProductionName string
param VnetProductionSubnetName string
param VnetDevelopmentName string
param VnetDevelopmentSubnetName string

resource NSGresource 'Microsoft.Network/networkSecurityGroups@2024-01-01' = {
  name: NSG_name
  location: NSG_location
  properties: {}
}


resource NSG_Allow_AzureFW_to_Dev_Subnet_Inbound 'Microsoft.Network/networkSecurityGroups/securityRules@2024-01-01' = {
  name: '${NSG_name}/Allow_AzureFW_to_Dev_Subnet_Inbound'
  properties: {
    protocol: 'TCP'
    sourcePortRange: '*'
    sourceAddressPrefix: '172.173.156.82'
    destinationAddressPrefix: '10.2.0.0/24'
    access: 'Allow'
    priority: 200
    direction: 'Inbound'
    sourcePortRanges: []
    destinationPortRanges: [
      '80'
      '443'
    ]
    sourceAddressPrefixes: []
    destinationAddressPrefixes: []
  }
  dependsOn: [
    NSGresource
  ]
}

resource NSG_Allow_AzureFW_to_Prod_Subnet_Inbound 'Microsoft.Network/networkSecurityGroups/securityRules@2024-01-01' = {
  name: '${NSG_name}/Allow_AzureFW_to_Prod_Subnet_Inbound'
  properties: {
    protocol: 'TCP'
    sourcePortRange: '*'
    sourceAddressPrefix: '172.173.156.82'
    destinationAddressPrefix: '10.1.0.0/24'
    access: 'Allow'
    priority: 100
    direction: 'Inbound'
    sourcePortRanges: []
    destinationPortRanges: [
      '80'
      '443'
    ]
    sourceAddressPrefixes: []
    destinationAddressPrefixes: []
  }
  dependsOn: [
    NSGresource
  ]
}

resource NSG_Allow_Dev_Subnet_Outbound_via_AzureFW 'Microsoft.Network/networkSecurityGroups/securityRules@2024-01-01' = {
  name: '${NSG_name}/Allow_Dev_Subnet_Outbound_via_AzureFW'
  properties: {
    protocol: '*'
    sourcePortRange: '*'
    sourceAddressPrefix: '10.2.0.0/24'
    destinationAddressPrefix: 'Internet'
    access: 'Allow'
    priority: 400
    direction: 'Outbound'
    sourcePortRanges: []
    destinationPortRanges: [
      '80'
      '443'
    ]
    sourceAddressPrefixes: []
    destinationAddressPrefixes: []
  }
  dependsOn: [
    NSGresource
  ]
}

resource NSG_Allow_Prod_Subnet_Outbound_via_AzureFW 'Microsoft.Network/networkSecurityGroups/securityRules@2024-01-01' = {
  name: '${NSG_name}/Allow_Prod_Subnet_Outbound_via_AzureFW'
  properties: {
    protocol: 'TCP'
    sourcePortRange: '*'
    sourceAddressPrefix: '10.1.0.0/24'
    destinationAddressPrefix: 'Internet'
    access: 'Allow'
    priority: 200
    direction: 'Outbound'
    sourcePortRanges: []
    destinationPortRanges: [
      '80'
      '443'
    ]
    sourceAddressPrefixes: []
    destinationAddressPrefixes: []
  }
  dependsOn: [
    NSGresource
  ]
}

resource NSG_Deny_All_Inbound_Traffic 'Microsoft.Network/networkSecurityGroups/securityRules@2024-01-01' = {
  name: '${NSG_name}/Deny_All_Inbound_Traffic'
  properties: {
    protocol: '*'
    sourcePortRange: '*'
    destinationPortRange: '*'
    sourceAddressPrefix: '*'
    destinationAddressPrefix: '*'
    access: 'Deny'
    priority: 4096
    direction: 'Inbound'
    sourcePortRanges: []
    destinationPortRanges: []
    sourceAddressPrefixes: []
    destinationAddressPrefixes: []
  }
  dependsOn: [
    NSGresource
  ]
}

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
      id:  NSGresource.id
    }
  }
  dependsOn: [
    NSGresource
  ]
}

resource subnetNSGDEV 'Microsoft.Network/virtualNetworks/subnets@2023-09-01' = {
  name: subnetDEV.name
  parent: vnetDEV
  properties: {
    networkSecurityGroup: {
      id:  NSGresource.id
    }
  }
  dependsOn: [
    NSGresource
  ]
}

