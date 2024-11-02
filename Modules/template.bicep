param firewallPolicies_azfwpolicy_name string = 'azfwpolicy'

resource firewallPolicies_azfwpolicy_name_resource 'Microsoft.Network/firewallPolicies@2024-01-01' = {
  name: firewallPolicies_azfwpolicy_name
  location: 'eastus'
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

resource firewallPolicies_azfwpolicy_name_DefaultNetworkRuleCollectionGroup 'Microsoft.Network/firewallPolicies/ruleCollectionGroups@2024-01-01' = {
  parent: firewallPolicies_azfwpolicy_name_resource
  name: 'DefaultNetworkRuleCollectionGroup'
  location: 'eastus'
  properties: {
    priority: 200
    ruleCollections: [
      {
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
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
        name: 'ProVnetRules'
        priority: 100
      }

      {
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
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
        name: 'DevVnetRules'
        priority: 200
      }

      {
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        action: {
          type: 'Deny'
        }
        rules: [
          {
            ruleType: 'NetworkRule'
            name: 'Dev DenyAllI'
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
              '*'
            ]
          }
          {
            ruleType: 'NetworkRule'
            name: 'Pro DenyAllI'
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
              '*'
            ]
          }

                  ]
        name: 'DenyAllRules'
        priority: 4096
      }
    ]
  }
}
