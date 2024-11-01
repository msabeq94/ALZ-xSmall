param VnetName string 
param VnetLocation string 
param VnetAddressPrefix string
param VnetSubnetName string
param VnetSubnetAddressPrefix string
param routtableID string


resource VirtualNetworksCENTVnet 'Microsoft.Network/virtualNetworks@2024-01-01' = if (VnetName == 'vf-core-CentralNetwork-central-NW-hub-vnet') {
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

resource VirtualNetworksVnet 'Microsoft.Network/virtualNetworks@2024-01-01' = if (VnetName != 'vf-core-CentralNetwork-central-NW-hub-vnet') {
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
          routeTable: {
            id: routtableID
          }
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

output VnetId string = VirtualNetworksVnet.id
output SubnetId string =  VirtualNetworksCENTVnet.properties.subnets[0].id
output subnetSP string = VirtualNetworksVnet.properties.subnets[0].id
