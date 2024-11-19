param publicIPAddName string
param publicIPAddLocation string

resource publicIPAddressesFW 'Microsoft.Network/publicIPAddresses@2024-01-01' = {
  name: publicIPAddName
  location: publicIPAddLocation
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
properties: {
    publicIPAllocationMethod: 'Static'
    publicIPAddressVersion: 'IPv4'
    idleTimeoutInMinutes: 4
  }
}

output publicIPAddressResourceId string = publicIPAddressesFW.id
output publicIPAddress string = publicIPAddressesFW.properties.ipAddress
