param ParVnetCentralNetworktName string
param ParVnetProductionName string
param ParVnetCentralNetworktAddressPrefix string
param ParVnetProductionAddressPrefix string
param ParVnetCentralNetworkid string
param ParVnetProductionid string


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
 
}


