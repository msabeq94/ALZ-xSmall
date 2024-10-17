param NSG_name string
param NSG_location string


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

output NSG_ID string = NSGresource.id
