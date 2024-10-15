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
param VnetLocation string

module ResourceGroupProductionSpoke 'Modules/ResourceGroupXSmall.bicep' = {
  name: 'ResourceGroupProductionSpoke'
  params: {
    rgName: rgNameProductionSpoke
    rgLocation: rgLocation
  }
}
output rgProductionSpokeId string = ResourceGroupProductionSpoke.outputs.rgXSmallId
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
