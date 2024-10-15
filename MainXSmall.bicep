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

module ResourceGroupProductionSpoke 'Modules/ResourceGroupXSmall.bicep' = {
  name: 'ResourceGroupProductionSpoke'
  params: {
    rgName: rgNameProductionSpoke
    rgLocation: rgLocation
  }
}

module ResourceGroupCentralNetwork 'Modules/ResourceGroupXSmall.bicep' = {
  name: 'ResourceGroupCentralNetwork'
  params: {
    rgName: rgNameCentralNetwork
    rgLocation: rgLocation
  }
}

module ResourceGroupDevelopmentSpoke 'Modules/ResourceGroupXSmall.bicep' = {
  name: 'ResourceGroupDevelopmentSpoke'
  params: {
    rgName: rgNameDevelopmentSpoke
    rgLocation: rgLocation
  }
}

module ResourceGroupInternalServicesHub 'Modules/ResourceGroupXSmall.bicep' = {
  name: 'ResourceGroupInternalServicesHub'
  params: {
    rgName: rgNameInternalServicesHub
    rgLocation: rgLocation
  }
}

module VirtualNetworkProduction 'Modules/VNetXSmall.bicep' = {
  name: 'VirtualNetworkProduction'
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
  name: 'VirtualNetworkDevelopment'
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
  name: 'VirtualNetworkCentralNetwork'
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
