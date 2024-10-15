param ParVnetDevelopmentName string 
param ParVnetLocation string 
param ParVnetDevelopmentAddressPrefix string
param ParVnetDevelopmentSubnetName string
param ParVnetDevelopmentSubnetAddressPrefix string

resource VirtualNetworksDevelopmentVnet 'Microsoft.Network/virtualNetworks@2024-01-01' = {
  name: ParVnetDevelopmentName
  location: ParVnetLocation
  properties: {
    addressSpace: {
      addressPrefixes: [
        ParVnetDevelopmentAddressPrefix
      ]
    }
    encryption: {
      enabled: false
      enforcement: 'AllowUnencrypted'
    }
    subnets: [
      {
        name: ParVnetDevelopmentSubnetName
        properties: {
          addressPrefixes: [
            ParVnetDevelopmentSubnetAddressPrefix
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
