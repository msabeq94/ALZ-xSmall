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
        // id: '/subscriptions/mgmtSubID/resourceGroups/CentralNetworkHub/providers/Microsoft.Network/azureFirewalls/ALZ-XSmall-FW/azureFirewallIpConfigurations/fw-public-ip'
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
      {
        name: 'ProDevNetworkAccessRules'
        // id: '${azureFirewalls_ALZ_XSmall_FW_name_resource.id}/networkRuleCollections/ProDevNetworkAccessRules'
        properties: {
          priority: 100
          action: {
            type: 'Allow'
          }
          rules: [
            {
              name: 'Pro HTTP Access'
              protocols: [
                'Any'
              ]
              sourceAddresses: [
                '*'
              ]
              destinationAddresses: [
                '10.1.0.0/16'
              ]
              sourceIpGroups: []
              destinationIpGroups: []
              destinationFqdns: []
              destinationPorts: [
                '80'
              ]
            }
            {
              name: 'Pro HTTPS Access'
              protocols: [
                'Any'
              ]
              sourceAddresses: [
                '*'
              ]
              destinationAddresses: [
                '10.1.0.0/16'
              ]
              sourceIpGroups: []
              destinationIpGroups: []
              destinationFqdns: []
              destinationPorts: [
                '443'
              ]
            }
            {
              name: 'Dev HTTP Access'
              protocols: [
                'Any'
              ]
              sourceAddresses: [
                '*'
              ]
              destinationAddresses: [
                '10.2.0.0/16'
              ]
              sourceIpGroups: []
              destinationIpGroups: []
              destinationFqdns: []
              destinationPorts: [
                '80'
              ]
            }
            {
              name: 'Dev HTTPS Access'
              protocols: [
                'Any'
              ]
              sourceAddresses: [
                '*'
              ]
              destinationAddresses: [
                '10.2.0.0/16'
              ]
              sourceIpGroups: []
              destinationIpGroups: []
              destinationFqdns: []
              destinationPorts: [
                '443'
              ]
            }
            {
              name: 'Pro SSH Access'
              protocols: [
                'Any'
              ]
              sourceAddresses: [
                '*'
              ]
              destinationAddresses: [
                '10.1.0.0/16'
              ]
              sourceIpGroups: []
              destinationIpGroups: []
              destinationFqdns: []
              destinationPorts: [
                '22'
              ]
            }
            {
              name: 'Pro RDP Access'
              protocols: [
                'Any'
              ]
              sourceAddresses: [
                '*'
              ]
              destinationAddresses: [
                '10.1.0.0/16'
              ]
              sourceIpGroups: []
              destinationIpGroups: []
              destinationFqdns: []
              destinationPorts: [
                '3389'
              ]
            }
            {
              name: 'Dev SSH Access'
              protocols: [
                'Any'
              ]
              sourceAddresses: [
                '*'
              ]
              destinationAddresses: [
                '10.2.0.0/16'
              ]
              sourceIpGroups: []
              destinationIpGroups: []
              destinationFqdns: []
              destinationPorts: [
                '22'
              ]
            }
            {
              name: 'Dev RDP Access'
              protocols: [
                'Any'
              ]
              sourceAddresses: [
                '*'
              ]
              destinationAddresses: [
                '10.2.0.0/16'
              ]
              sourceIpGroups: []
              destinationIpGroups: []
              destinationFqdns: []
              destinationPorts: [
                '3389'
              ]
            }
          ]
        }
      }
    ]
 
  
  
  }}

    

    
