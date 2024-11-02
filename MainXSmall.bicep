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
param VnetProductionid string
param VnetDevelopmentName string
param VnetDevelopmentAddressPrefix string
param VnetDevelopmentSubnetName string
param VnetDevelopmentSubnetAddressPrefix string
param VnetDevelopmentid string
param VnetCentralNetworktName string
param VnetCentralNetworkAddressPrefix string
param VnetCentralNetworkSubnetName string
param VnetCentralNetworkSubnetAddressPrefix string
param VnetCentralNetworkid string
param VnetLocation string
param FWpublicIPAddName string
param FWName string
param devspoke_NSG_name string
param ProSpoke_NSG_name string
param HubRouteTableName string
param routtableID string
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
    RouteTable
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
    RouteTable
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
    RouteTable
  ]
}

module VnetPeeringPRO_CENT 'Modules/VNetPeeringXSmall.bicep' = {
  name: 'VnetPeeringPRO_CENT-${deploymentTime}'
  scope: resourceGroup(rgNameProductionSpoke)
  params: {
    VnetPeeringName: '${VnetProductionName}/PRO_CENT_peering'
    RemoteVnetID: VnetCentralNetworkid
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
    RemoteVnetID: VnetProductionid
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
    RemoteVnetID: VnetCentralNetworkid
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
    RemoteVnetID: VnetDevelopmentid
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

module NSGPro 'Modules/NSGXSmall.bicep' = {
  name: 'NSG-${deploymentTime}'
  scope: resourceGroup(rgNameProductionSpoke)
  params: {
    devspoke_NSG_name : devspoke_NSG_name
    NSG_location: VnetLocation
    ProSpoke_NSG_name: ProSpoke_NSG_name
    evn:  'prod'

  }
  dependsOn: [
    
    VirtualNetworkProduction
  ]
}

module NSGdev 'Modules/NSGXSmall.bicep' = {
  name: 'NSG-${deploymentTime}'
  scope: resourceGroup(rgNameDevelopmentSpoke)
  params: {
    devspoke_NSG_name : devspoke_NSG_name
    NSG_location: VnetLocation
    ProSpoke_NSG_name: ProSpoke_NSG_name
    evn:  'dev'

  }
  dependsOn: [
    VirtualNetworkDevelopment
  ]
}

module NSGAssociatePRO 'Modules/NSGXSmallAssociate.bicep' = {
  name: 'NSGAssociate-${deploymentTime}'
  scope: resourceGroup(rgNameProductionSpoke)
  params: {
    VnetName: VnetProductionName
    VnetSubnetName: VnetProductionSubnetName
    SUBaddressPrefix: VnetProductionSubnetAddressPrefix
    NSGID: NSGPro.outputs.ProSpokeNsgId
  }
  dependsOn: [
    NSGPro
    VirtualNetworkProduction
  ]
}

module NSGAssociateDEV 'Modules/NSGXSmallAssociate.bicep' = {
  name: 'NSGAssociate-${deploymentTime}'
  scope: resourceGroup(rgNameDevelopmentSpoke)
  params: {
    VnetName: VnetDevelopmentName
    VnetSubnetName: VnetDevelopmentSubnetName
    SUBaddressPrefix: VnetDevelopmentSubnetAddressPrefix
    NSGID: NSGdev.outputs.devNsgId
  }
  dependsOn: [
    NSGdev
    VirtualNetworkDevelopment
  ]
}

module PolicyDefinitions 'Modules/PolicyDefinitionsXSmall.bicep' = {
  name: 'PolicyDefinitions-${deploymentTime}'
  scope: subscription()

}

module PolicyAssignments 'Modules/PolicyassignmentsXSmal.bicep' = {
  name: 'PolicyAssignments-${deploymentTime}'
  scope: resourceGroup(rgNameInternalServicesHub)
  dependsOn: [
    PolicyDefinitions
    ResourceGroupInternalServicesHub
  ]
}

module RouteTable 'Modules/RouteTable.bicep' = {
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

