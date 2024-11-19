targetScope = 'subscription'

param rgNameProductionSpoke string
param rgNameCentralNetwork string
param rgNameDevelopmentSpoke string
param rgNameInternalServicesHub string
param rgLocation string
param VnetProductionName string
param VnetProductionAddressPrefix string
param VnetProductionSubnetName string
param VnetProductionSubnetAddressPrefix string
param VnetDevelopmentName string
param VnetDevelopmentAddressPrefix string
param VnetDevelopmentSubnetName string
param VnetDevelopmentSubnetAddressPrefix string
param VnetCentralNetworktName string
param VnetCentralNetworkAddressPrefix string
param VnetCentralNetworkSubnetName string
param VnetCentralNetworkSubnetAddressPrefix string
param VnetLocation string
param FWpublicIPAddName string
param FWName string
param NSG_name_DEV string
param NSG_name_PROD string
param HubRouteTableName string
param deploymentTime string = utcNow()

module ResourceGroupProductionSpoke 'Modules/ResourceGroupXSmall.bicep' = {
  name: 'ResourceGroupProductionSpoke-${deploymentTime}'
  params: {
    rgName: rgNameProductionSpoke
    rgLocation: rgLocation
  }
}

module ResourceGroupCentralNetwork 'Modules/ResourceGroupXSmall.bicep' = {
  name: 'ResourceGroupCentralNetwork-${deploymentTime}'
  params: {
    rgName: rgNameCentralNetwork
    rgLocation: rgLocation
  }
}

module ResourceGroupDevelopmentSpoke 'Modules/ResourceGroupXSmall.bicep' = {
  name: 'ResourceGroupDevelopmentSpoke-${deploymentTime}'
  params: {
    rgName: rgNameDevelopmentSpoke
    rgLocation: rgLocation
  }
}

module ResourceGroupInternalServicesHub 'Modules/ResourceGroupXSmall.bicep' = {
  name: 'ResourceGroupInternalServicesHub-${deploymentTime}'
  params: {
    rgName: rgNameInternalServicesHub
    rgLocation: rgLocation
  }
}

module VirtualNetworkProduction 'Modules/VNetXSmall.bicep' = {
  name: 'VirtualNetworkProduction-${deploymentTime}'
  scope: resourceGroup(rgNameProductionSpoke)
  params: {
    VnetName: VnetProductionName
    VnetLocation: VnetLocation
    VnetAddressPrefix: VnetProductionAddressPrefix
    VnetSubnetName: VnetProductionSubnetName
    VnetSubnetAddressPrefix: VnetProductionSubnetAddressPrefix
   
  }
  dependsOn: [
    ResourceGroupProductionSpoke
    RouteTableXSmall
  ]
}

module VirtualNetworkDevelopment 'Modules/VNetXSmall.bicep' = {
  name: 'VirtualNetworkDevelopment-${deploymentTime}'
  scope: resourceGroup(rgNameDevelopmentSpoke)
  params: {
    VnetName: VnetDevelopmentName
    VnetLocation: VnetLocation
    VnetAddressPrefix: VnetDevelopmentAddressPrefix
    VnetSubnetName: VnetDevelopmentSubnetName
    VnetSubnetAddressPrefix: VnetDevelopmentSubnetAddressPrefix
   
  }
  dependsOn: [
    ResourceGroupDevelopmentSpoke
    RouteTableXSmall
  ]
}

module VirtualNetworkCentralNetwork 'Modules/VNetXSmall.bicep' = {
  name: 'VirtualNetworkCentralNetwork-${deploymentTime}'
  scope: resourceGroup(rgNameCentralNetwork)
  params: {
    VnetName: VnetCentralNetworktName
    VnetLocation: VnetLocation
    VnetAddressPrefix: VnetCentralNetworkAddressPrefix
    VnetSubnetName: VnetCentralNetworkSubnetName
    VnetSubnetAddressPrefix: VnetCentralNetworkSubnetAddressPrefix
   
  }
  dependsOn: [
    ResourceGroupCentralNetwork
    RouteTableXSmall
  ]
}

module VnetPeeringPRO_CENT 'Modules/VNetPeeringXSmall.bicep' = {
  name: 'VnetPeeringPRO_CENT-${deploymentTime}'
  scope: resourceGroup(rgNameProductionSpoke)
  params: {
    VnetPeeringName: '${VnetProductionName}/PRO_CENT_peering'
    RemoteVnetID: VirtualNetworkCentralNetwork.outputs.VnetId
    RemoteNetworkAddressPrefix: VnetCentralNetworkAddressPrefix
  }
  dependsOn: [
    VirtualNetworkProduction
    VirtualNetworkCentralNetwork
  ]
}

module VnetPeeringCEN_PRO 'Modules/VNetPeeringXSmall.bicep' = {
  name: 'VnetPeeringCEN_PRO-${deploymentTime}'
  scope: resourceGroup(rgNameCentralNetwork)
  params: {
    VnetPeeringName: '${VnetCentralNetworktName}/CEN_PRO_peering'
    RemoteVnetID: VirtualNetworkProduction.outputs.VnetId
    RemoteNetworkAddressPrefix: VnetProductionAddressPrefix
  }
  dependsOn: [
    VirtualNetworkCentralNetwork
    VirtualNetworkProduction
  ]
}
module VnetPeeringDEV_CENT 'Modules/VNetPeeringXSmall.bicep' = {
  name: 'VnetPeeringDEV_CENT-${deploymentTime}'
  scope: resourceGroup(rgNameDevelopmentSpoke)
  params: {
    VnetPeeringName: '${VnetDevelopmentName}/DEV_CENT_peering'
    RemoteVnetID: VirtualNetworkCentralNetwork.outputs.VnetId
    RemoteNetworkAddressPrefix: VnetCentralNetworkAddressPrefix
  }
  dependsOn: [
    VirtualNetworkDevelopment
    VirtualNetworkCentralNetwork
  ]
}

module VnetPeeringCENT_DEV 'Modules/VNetPeeringXSmall.bicep' = {
  name: 'VnetPeeringCENT_DEV-${deploymentTime}'
  scope: resourceGroup(rgNameCentralNetwork)
  params: {
    VnetPeeringName: '${VnetCentralNetworktName}/CENT_DEV_peering'
    RemoteVnetID: VirtualNetworkDevelopment.outputs.VnetId
    RemoteNetworkAddressPrefix: VnetDevelopmentAddressPrefix
  }
  dependsOn: [
    VirtualNetworkCentralNetwork
    VirtualNetworkDevelopment
  ]
}

module FWpublicIP 'Modules/FWpubliceIP.bicep' = {
  name: 'FWpublicIP-${deploymentTime}'
  scope: resourceGroup(rgNameCentralNetwork)
  params: {
    publicIPAddName: FWpublicIPAddName
    publicIPAddLocation: VnetLocation
  }
  dependsOn: [
    ResourceGroupCentralNetwork
  ]
  
}

module FW 'Modules/FWXSmall.bicep' = {
  name: 'FW-${deploymentTime}'
  scope: resourceGroup(rgNameCentralNetwork)
  params: {
    FWName: FWName
    FWLocation: VnetLocation
    FWpublicIPAddName: FWpublicIPAddName
    publicIPAddressID: FWpublicIP.outputs.publicIPAddressResourceId
    subnetID: VirtualNetworkCentralNetwork.outputs.SubnetId
   
  }
  dependsOn: [
    FWpublicIP
    VirtualNetworkCentralNetwork
  ]
}

module NSGPROD 'Modules/NSGXSmall.bicep' = {
  name: 'NSG-${deploymentTime}'
  scope: resourceGroup(rgNameProductionSpoke)
  params: {
    NSG_name : NSG_name_PROD
    NSG_location: VnetLocation
    NSG_addressPrefix_FWIP: FWpublicIP.outputs.publicIPAddress
  }
  dependsOn: [
    
    VirtualNetworkProduction
  ]
}

module NSGDEV 'Modules/NSGXSmall.bicep' = {
  name: 'NSG-${deploymentTime}'
  scope: resourceGroup(rgNameDevelopmentSpoke)
  params: {
    NSG_name : NSG_name_DEV
    NSG_location: VnetLocation
    NSG_addressPrefix_FWIP: FWpublicIP.outputs.publicIPAddress
  }
  dependsOn: [
    
    VirtualNetworkDevelopment
  ]
}
module PolicyDefinitions 'Modules/PolicyDefinitionsXSmall.bicep' = {
  name: 'PolicyDefinitions-${deploymentTime}'
  scope: subscription()

}

module PolicyAssignments 'Modules/PolicyassignmentsXSmall.bicep' = {
  name: 'PolicyAssignments-${deploymentTime}'
  scope: resourceGroup(rgNameInternalServicesHub)
  dependsOn: [
    PolicyDefinitions
    ResourceGroupInternalServicesHub
  ]
}

module RouteTableXSmall 'Modules/RouteTableXSmall.bicep' = {
  name: 'RouteTable-${deploymentTime}'
  scope: resourceGroup(rgNameCentralNetwork)
  params: {
    HubRouteTableName: HubRouteTableName
    RTLocation: VnetLocation
    FWIP: FWpublicIP.outputs.publicIPAddress
  }
  dependsOn: [
    ResourceGroupCentralNetwork
    FWpublicIP
   
  ]
}

module RouteTableAssociatePRO 'Modules/NSG_RT_Associate.bicep' = {
  name: 'RouteTableAssociate-${deploymentTime}'
  scope: resourceGroup(rgNameProductionSpoke)
  params: {
    VnetName: VnetProductionName
    VnetSubnetName: VnetProductionSubnetName
    routeTablesID: RouteTableXSmall.outputs.resHubRouteTableId
    SUBaddressPrefix: VnetProductionSubnetAddressPrefix
    networkSecurityGroups_vf_core_alz_nsg_PROD_externalid: NSGPROD.outputs.NsgId
  }
  dependsOn: [
    RouteTableXSmall
  ]
}

module RouteTableAssociateDEV 'Modules/NSG_RT_Associate.bicep' = {
  name: 'RouteTableAssociate-${deploymentTime}'
  scope: resourceGroup(rgNameDevelopmentSpoke)
  params: {
    VnetName: VnetDevelopmentName
    VnetSubnetName: VnetDevelopmentSubnetName
    routeTablesID: RouteTableXSmall.outputs.resHubRouteTableId
    SUBaddressPrefix: VnetDevelopmentSubnetAddressPrefix
    networkSecurityGroups_vf_core_alz_nsg_PROD_externalid: NSGDEV.outputs.NsgId
  }
  dependsOn: [
    RouteTableXSmall
  ]
}

