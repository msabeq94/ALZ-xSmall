param VnetPeeringName string
param RemoteVnetID string
param RemoteNetworkAddressPrefix string


resource VnetPeering'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2024-01-01' = {
  name: VnetPeeringName
  properties: {
    peeringState: 'Connected'
    peeringSyncLevel: 'FullyInSync'
    remoteVirtualNetwork: {
      id: RemoteVnetID
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
    doNotVerifyRemoteGateways: false
    peerCompleteVnets: true
    remoteAddressSpace: {
      addressPrefixes: [
        RemoteNetworkAddressPrefix 
      ]
    }
    remoteVirtualNetworkAddressSpace: {
      addressPrefixes: [
        RemoteNetworkAddressPrefix 
      ]
    }
  }
 
}

