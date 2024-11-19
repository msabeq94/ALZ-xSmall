param virtualNetworks_vf_core_ProductionSpoke_production_vnet_name string = 'vf-core-ProductionSpoke-production-vnet'
param networkSecurityGroups_vf_core_alz_nsg_PROD_externalid string = '/subscriptions/102170e2-9371-4b66-95de-d4530f8bf56e/resourceGroups/ProductionSpoke/providers/Microsoft.Network/networkSecurityGroups/vf-core-alz-nsg-PROD'
param routeTables_vf_core_alz_rt_externalid string = '/subscriptions/102170e2-9371-4b66-95de-d4530f8bf56e/resourceGroups/CentralNetworkHub/providers/Microsoft.Network/routeTables/vf-core-alz-rt'
param virtualNetworks_vf_core_CentralNetwork_central_NW_hub_vnet_externalid string = '/subscriptions/102170e2-9371-4b66-95de-d4530f8bf56e/resourceGroups/CentralNetworkHub/providers/Microsoft.Network/virtualNetworks/vf-core-CentralNetwork-central-NW-hub-vnet'

resource virtualNetworks_vf_core_ProductionSpoke_production_vnet_name_resource 'Microsoft.Network/virtualNetworks@2024-01-01' = {
  name: virtualNetworks_vf_core_ProductionSpoke_production_vnet_name
  location: 'eastus'
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.1.0.0/16'
      ]
    }
    encryption: {
      enabled: false
      enforcement: 'AllowUnencrypted'
    }
    subnets: [
      {
        name: 'ProductionSubnet'
        id: virtualNetworks_vf_core_ProductionSpoke_production_vnet_name_ProductionSubnet.id
        properties: {
          addressPrefix: '10.1.0.0/24'
          networkSecurityGroup: {
            id: networkSecurityGroups_vf_core_alz_nsg_PROD_externalid
          }
          routeTable: {
            id: routeTables_vf_core_alz_rt_externalid
          }
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
        type: 'Microsoft.Network/virtualNetworks/subnets'
      }
    ]
    virtualNetworkPeerings: [
      {
        name: 'PRO_CENT_peering'
        id: virtualNetworks_vf_core_ProductionSpoke_production_vnet_name_PRO_CENT_peering.id
        properties: {
          peeringState: 'Connected'
          peeringSyncLevel: 'FullyInSync'
          remoteVirtualNetwork: {
            id: virtualNetworks_vf_core_CentralNetwork_central_NW_hub_vnet_externalid
          }
          allowVirtualNetworkAccess: true
          allowForwardedTraffic: false
          allowGatewayTransit: false
          useRemoteGateways: false
          doNotVerifyRemoteGateways: false
          peerCompleteVnets: true
          remoteAddressSpace: {
            addressPrefixes: [
              '10.10.0.0/16'
            ]
          }
          remoteVirtualNetworkAddressSpace: {
            addressPrefixes: [
              '10.10.0.0/16'
            ]
          }
        }
        type: 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings'
      }
    ]
    enableDdosProtection: false
  }
}

resource virtualNetworks_vf_core_ProductionSpoke_production_vnet_name_ProductionSubnet 'Microsoft.Network/virtualNetworks/subnets@2024-01-01' = {
  name: '${virtualNetworks_vf_core_ProductionSpoke_production_vnet_name}/ProductionSubnet'
  properties: {
    addressPrefix: '10.1.0.0/24'
    networkSecurityGroup: {
      id: networkSecurityGroups_vf_core_alz_nsg_PROD_externalid
    }
    routeTable: {
      id: routeTables_vf_core_alz_rt_externalid
    }
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_vf_core_ProductionSpoke_production_vnet_name_resource
  ]
}

resource virtualNetworks_vf_core_ProductionSpoke_production_vnet_name_PRO_CENT_peering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2024-01-01' = {
  name: '${virtualNetworks_vf_core_ProductionSpoke_production_vnet_name}/PRO_CENT_peering'
  properties: {
    peeringState: 'Connected'
    peeringSyncLevel: 'FullyInSync'
    remoteVirtualNetwork: {
      id: virtualNetworks_vf_core_CentralNetwork_central_NW_hub_vnet_externalid
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
    doNotVerifyRemoteGateways: false
    peerCompleteVnets: true
    remoteAddressSpace: {
      addressPrefixes: [
        '10.10.0.0/16'
      ]
    }
    remoteVirtualNetworkAddressSpace: {
      addressPrefixes: [
        '10.10.0.0/16'
      ]
    }
  }
  dependsOn: [
    virtualNetworks_vf_core_ProductionSpoke_production_vnet_name_resource
  ]
}