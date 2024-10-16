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
