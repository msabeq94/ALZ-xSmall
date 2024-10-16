param VnetCentralNetworktName string
param VnetProductionName string
param VnetCentralNetworkAddressPrefix string
param VnetProductionAddressPrefix string
param VnetCentralNetworkid string
param VnetProductionid string
param VnetDevelopmentName string
param VnetDevelopmentAddressPrefix string
param VnetDevelopmentid string

resource VnetPeeringPRO_CENT_peering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2024-01-01' = {
  name: '${VnetProductionName}/PRO_CENT_peering'
  properties: {
    peeringState: 'Connected'
    peeringSyncLevel: 'FullyInSync'
    remoteVirtualNetwork: {
      id: VnetCentralNetworkid
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
    doNotVerifyRemoteGateways: false
    peerCompleteVnets: true
    remoteAddressSpace: {
      addressPrefixes: [
        VnetCentralNetworkAddressPrefix
      ]
    }
    remoteVirtualNetworkAddressSpace: {
      addressPrefixes: [
        VnetCentralNetworkAddressPrefix
      ]
    }
  }
 
}


resource VnetPeeringCEN_PRO_peering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2024-01-01' = {
  name: '${VnetCentralNetworktName}/CEN_PRO_peering'
  properties: {
    peeringState: 'Connected'
    peeringSyncLevel: 'FullyInSync'
    remoteVirtualNetwork: {
      id: VnetProductionid
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
    doNotVerifyRemoteGateways: false
    peerCompleteVnets: true
    remoteAddressSpace: {
      addressPrefixes: [
        VnetProductionAddressPrefix
      ]
    }
    remoteVirtualNetworkAddressSpace: {
      addressPrefixes: [
        VnetProductionAddressPrefix
      ]
    }
  }
 
}

resource VnetPeeringDEV_CENT_peering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2024-01-01' = {
  name: '${VnetDevelopmentName}/DEV_CENT_peering'
  properties: {
    peeringState: 'Connected'
    peeringSyncLevel: 'FullyInSync'
    remoteVirtualNetwork: {
      id: VnetCentralNetworkid
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
    doNotVerifyRemoteGateways: false
    peerCompleteVnets: true
    remoteAddressSpace: {
      addressPrefixes: [
        VnetCentralNetworkAddressPrefix
      ]
    }
    remoteVirtualNetworkAddressSpace: {
      addressPrefixes: [
        VnetCentralNetworkAddressPrefix
      ]
    }
  }
 
}

resource VnetPeeringCENT_DEV_peering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2024-01-01' = {
  name: '${VnetCentralNetworktName}/CENT_DEV_peering'
  properties: {
    peeringState: 'Connected'
    peeringSyncLevel: 'FullyInSync'
    remoteVirtualNetwork: {
      id: VnetDevelopmentid
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
    doNotVerifyRemoteGateways: false
    peerCompleteVnets: true
    remoteAddressSpace: {
      addressPrefixes: [
        VnetDevelopmentAddressPrefix
      ]
    }
    remoteVirtualNetworkAddressSpace: {
      addressPrefixes: [
        VnetDevelopmentAddressPrefix
      ]
    }
  }
 
}





