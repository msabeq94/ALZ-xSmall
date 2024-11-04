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
      tier: 'basic'
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
 
    firewallPolicy: {
      id: resFirewallPolicies.id
  
  }
  
  }
dependsOn: [

  firewallPoliciesCollectionGroup 
]
}



resource resFirewallPolicies 'Microsoft.Network/firewallPolicies@2024-01-01' = {
  name: 'azfwpolicy'
  location:FWLocation
  
  properties: {
    sku: {
      tier: 'Standard'
    }
    threatIntelMode: 'Alert'
    dnsSettings: {
      servers: []
      enableProxy: true
    }
  }
}

resource firewallPoliciesCollectionGroup 'Microsoft.Network/firewallPolicies/ruleCollectionGroups@2024-01-01' = {
  parent: resFirewallPolicies
  name: 'vf-core-alz-fwPolicy-rule-collection'
  location: FWLocation
  properties: {
    priority: 200
    ruleCollections: [
      {
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        name: 'ProVnetRules'
        priority: 100
        action: {
          type: 'Allow'
        }
        rules: [
          {
            ruleType: 'NetworkRule'
            name: 'Pro HTTP Access'
            ipProtocols: [
              'Any'
            ]
            sourceAddresses: [
              '*'
            ]
            sourceIpGroups: []
            destinationAddresses: [
              '10.1.0.0/16'
            ]
            destinationIpGroups: []
            destinationFqdns: []
            destinationPorts: [
              '80'
            ]
          }
          {
            ruleType: 'NetworkRule'
            name: 'Pro HTTPS Access'
            ipProtocols: [
              'Any'
            ]
            sourceAddresses: [
              '*'
            ]
            sourceIpGroups: []
            destinationAddresses: [
              '10.1.0.0/16'
            ]
            destinationIpGroups: []
            destinationFqdns: []
            destinationPorts: [
              '443'
            ]
          }
          {ruleType: 'NetworkRule'
          name: 'Pro SSH Access'
          ipProtocols: [
            'Any'
          ]
          sourceAddresses: [
            '*'
          ]
          sourceIpGroups: []
          destinationAddresses: [
            '10.1.0.0/16'
          ]
          destinationIpGroups: []
          destinationFqdns: []
          destinationPorts: [
            '22'
          ]
        }
        {
          ruleType: 'NetworkRule'
            name: 'Pro RDP Access'
            ipProtocols: [
              'Any'
            ]
            sourceAddresses: [
              '*'
            ]
            sourceIpGroups: []
            destinationAddresses: [
              '10.1.0.0/16'
            ]
            destinationIpGroups: []
            destinationFqdns: []
            destinationPorts: [
              '3389'
            ]
        }
        {
          ruleType: 'NetworkRule'
            name: 'Pro BastionHost Communication'
            ipProtocols: [
              'TCP'
            ]
            sourceAddresses: [
              '*'
            ]
            sourceIpGroups: []
            destinationAddresses: [
              '10.1.0.0/16'
            ]
            destinationIpGroups: []
            destinationFqdns: []
            destinationPorts: [
              '8080'
              '5701'
            ]
        }
        ]
       
      }

      {
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        name: 'DevVnetRules'
        priority: 200
        action: {
          type: 'Allow'
        }
        rules: [
          {
            ruleType: 'NetworkRule'
            name: 'Dev HTTP Access'
            ipProtocols: [
              'Any'
            ]
            sourceAddresses: [
              '*'
            ]
            sourceIpGroups: []
            destinationAddresses: [
              '10.2.0.0/16'
            ]
            destinationIpGroups: []
            destinationFqdns: []
            destinationPorts: [
              '80'
            ]
          }
          {
            ruleType: 'NetworkRule'
            name: 'Dev HTTPS Access'
            ipProtocols: [
              'Any'
            ]
            sourceAddresses: [
              '*'
            ]
            sourceIpGroups: []
            destinationAddresses: [
              '10.2.0.0/16'
            ]
            destinationIpGroups: []
            destinationFqdns: []
            destinationPorts: [
              '443'
            ]
          }
          {ruleType: 'NetworkRule'
          name: 'Dev SSH Access'
          ipProtocols: [
            'Any'
          ]
          sourceAddresses: [
            '*'
          ]
          sourceIpGroups: []
          destinationAddresses: [
            '10.2.0.0/16'
          ]
          destinationIpGroups: []
          destinationFqdns: []
          destinationPorts: [
            '22'
          ]
        }
        {
          ruleType: 'NetworkRule'
            name: 'Dev RDP Access'
            ipProtocols: [
              'Any'
            ]
            sourceAddresses: [
              '*'
            ]
            sourceIpGroups: []
            destinationAddresses: [
              '10.2.0.0/16'
            ]
            destinationIpGroups: []
            destinationFqdns: []
            destinationPorts: [
              '3389'
            ]
        }
        {
          ruleType: 'NetworkRule'
            name: 'Dev BastionHost Communication'
            ipProtocols: [
              'TCP'
            ]
            sourceAddresses: [
              '*'
            ]
            sourceIpGroups: []
            destinationAddresses: [
              '10.2.0.0/16'
            ]
            destinationIpGroups: []
            destinationFqdns: []
            destinationPorts: [
              '8080'
              '5701'
            ]
        }
        ]
      
      }

      
    ]
  }
}

    
