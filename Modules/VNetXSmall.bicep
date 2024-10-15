param VnetName string 
param VnetLocation string 
param VnetAddressPrefix string
param VnetSubnetName string
param VnetSubnetAddressPrefix string


resource VirtualNetworksVnet 'Microsoft.Network/virtualNetworks@2024-01-01' = {
  name: VnetName
  location: VnetLocation
  properties: {
    addressSpace: {
      addressPrefixes: [
        VnetAddressPrefix
      ]
    }
    encryption: {
      enabled: false
      enforcement: 'AllowUnencrypted'
    }
    subnets: [
      {
        name: VnetSubnetName
        properties: {
          addressPrefixes: [
            VnetSubnetAddressPrefix
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

