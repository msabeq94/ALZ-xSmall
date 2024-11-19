param FWName string
param FWLocation string
param FWpublicIPAddName string
param publicIPAddressID string
param subnetID string





resource XSmallFW 'Microsoft.Network/azureFirewalls@2024-01-01' = {
  name: FWName 
  location: FWLocation
  properties: {
    sku: {
      name: 'AZFW_VNet'
      tier: 'Standard'
    }
    threatIntelMode: 'Alert'
    additionalProperties: {}
    ipConfigurations: [
      {
        name: FWpublicIPAddName
        properties: {
          publicIPAddress: {
            id: publicIPAddressID
          }
          subnet: {
            id: subnetID
          }
        }
      }
    ]
    networkRuleCollections: [
    
     ]

  
  }

}

