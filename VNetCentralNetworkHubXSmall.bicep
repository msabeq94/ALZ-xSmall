param ParVnetCentralNetworktName string 
param ParVnetLocation string 
param ParVnetCentralNetworktAddressPrefix string
param ParVnetCentralNetworktSubnetName string
param ParVnetCentralNetworktSubnetAddressPrefix string
param ParVnetProductionid string
param ParVnetProductionAddressPrefix string

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

resource VnetPeeringCEN_PRO_peering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2024-01-01' = {
  name: '${ParVnetCentralNetworktName}/CEN_PRO_peering'
  properties: {
    peeringState: 'Connected'
    peeringSyncLevel: 'FullyInSync'
    remoteVirtualNetwork: {
      id: ParVnetProductionid
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
    doNotVerifyRemoteGateways: false
    peerCompleteVnets: true
    remoteAddressSpace: {
      addressPrefixes: [
        ParVnetProductionAddressPrefix
      ]
    }
    remoteVirtualNetworkAddressSpace: {
      addressPrefixes: [
        ParVnetProductionAddressPrefix
      ]
    }
  }
  dependsOn: [
    VirtualNetworksCentralNetworktVnet
  ]
}
