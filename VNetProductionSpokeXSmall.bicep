param ParVnetProductionName string 
param ParVnetLocation string 
param ParVnetProductionAddressPrefix string
param ParVnetProductionSubnetName string
param ParVnetProductionSubnetAddressPrefix string
param ParVnetCentralNetworkid string
param ParVnetCentralNetworktAddressPrefix string

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

resource VnetPeeringPRO_CENT_peering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2024-01-01' = {
  name: '${ParVnetProductionName}/PRO_CENT_peering'
  properties: {
    peeringState: 'Connected'
    peeringSyncLevel: 'FullyInSync'
    remoteVirtualNetwork: {
      id: ParVnetCentralNetworkid
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
    doNotVerifyRemoteGateways: false
    peerCompleteVnets: true
    remoteAddressSpace: {
      addressPrefixes: [
        ParVnetCentralNetworktAddressPrefix
      ]
    }
    remoteVirtualNetworkAddressSpace: {
      addressPrefixes: [
        ParVnetCentralNetworktAddressPrefix
      ]
    }
  }
  dependsOn: [
    VirtualNetworksCentralNetworktVnet,VnetPeeringCEN_PRO_peering
  ]
}
