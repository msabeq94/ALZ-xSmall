param ParVnetProductionName string 
param ParVnetLocation string 
param ParVnetProductionAddressPrefix string
param ParVnetProductionSubnetName string
param ParVnetProductionSubnetAddressPrefix string

resource VirtualNetworksProductionVnet 'Microsoft.Network/virtualNetworks@2024-01-01' = {
  name: ParVnetProductionName
  location: ParVnetLocation
  properties: {
    addressSpace: {
      addressPrefixes: [
        ParVnetProductionAddressPrefix
      ]
    }
    encryption: {
      enabled: false
      enforcement: 'AllowUnencrypted'
    }
    subnets: [
      {
        name: ParVnetProductionSubnetName
        properties: {
          addressPrefixes: [
            ParVnetProductionSubnetAddressPrefix
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
