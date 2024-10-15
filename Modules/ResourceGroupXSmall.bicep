
targetScope='subscription'

param rgName string
param rgLocation string

resource ProductionSpoke 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: rgName
  location: rgLocation
}




