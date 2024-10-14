
targetScope='subscription'

param ParResourceGroupProductionSpokeName string
param ParResourceGroupCentralNetworkName string
param ParResourceGroupdevelopmentSpokeName string
param ParResourceGroupInternalServicesHubName string
param ParResourceGroupLocation string

resource ProductionSpoke 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: ParResourceGroupProductionSpokeName
  location: ParResourceGroupLocation
}

resource CentralNetwork 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: ParResourceGroupCentralNetworkName
  location: ParResourceGroupLocation
}
resource DevelopmentSpoke 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: ParResourceGroupdevelopmentSpokeName
  location: ParResourceGroupLocation
}
resource InternalServicesHub 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: ParResourceGroupInternalServicesHubName
  location: ParResourceGroupLocation
}





