param ParVnetCentralNetworktName string 
param ParVnetLocation string 
param ParVnetCentralNetworktAddressPrefix string
param ParVnetCentralNetworktSubnetName string
param ParVnetCentralNetworktSubnetAddressPrefix string
param ParVnetProductionid string
param ParVnetProductionAddressPrefix string
param ParVnetProductionName string
param ParVnetCentralNetworkid string

resource VirtualNetworksCentralNetworktVnet 'Microsoft.Network/virtualNetworks@2024-01-01' = {
  name: ParVnetCentralNetworktName
  location: ParVnetLocation
  properties: {
    addressSpace: {
      addressPrefixes: [
        ParVnetCentralNetworktAddressPrefix
      ]
    }
    encryption: {
      enabled: false
      enforcement: 'AllowUnencrypted'
    }
    subnets: [
      {
        name: ParVnetCentralNetworktSubnetName
        properties: {
          addressPrefixes: [
            ParVnetCentralNetworktSubnetAddressPrefix
          ]
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
        type: 'Microsoft.Network/virtualNetworks/subnets'
      }
    ]
    virtualNetworkPeerings: []
    enableDdosProtection: false
  }
}
