targetScope = 'subscription'
var varCustomPolicyDefinitionsArrayXSmall = [
  // {
  //   name: 'Audit-RDP-From-Internet'
  //   libDefinition: loadJsonContent('policy_definitions/Audit-RDP-From-Internet.json')
  // }
  
  {
    name: 'Audit-Subnet-Without-Nsg'
    libDefinition: loadJsonContent('policy_definitions/Audit-Subnet-Without-Nsg.json')
  }
  
  {
    name: 'Audit-Subnet-Without-Udr'
    libDefinition: loadJsonContent('policy_definitions/Audit-Subnet-Without-Udr.json')
  }
  
  {
    name: 'Deny-Private-DNS-Zones'
    libDefinition: loadJsonContent('policy_definitions/Deny-Private-DNS-Zones.json')
  }
  
  {
    name: 'Deny-VNet-Peering'
    libDefinition: loadJsonContent('policy_definitions/Deny-VNet-Peering.json')
  }
  
  {
    name: 'Deploy-Custom-Route-Table'
    libDefinition: loadJsonContent('policy_definitions/Deploy-Custom-Route-Table.json')
  }
  
  {
    name: 'Deploy-DDoSProtection'
    libDefinition: loadJsonContent('policy_definitions/Deploy-DDoSProtection.json')
  }
  
  {
    name: 'Deploy-FirewallPolicy'
    libDefinition: loadJsonContent('policy_definitions/Deploy-FirewallPolicy.json')
  }
  
  {
    name: 'Deploy-VNET-HubSpoke'
    libDefinition: loadJsonContent('policy_definitions/Deploy-VNET-HubSpoke.json')
  }
]



resource resPolicyDefinitions 'Microsoft.Authorization/policyDefinitions@2023-04-01' = [for policy in varCustomPolicyDefinitionsArrayXSmall: {
  name: policy.libDefinition.name
  properties: {
    description: policy.libDefinition.properties.description
    displayName: policy.libDefinition.properties.displayName
    metadata: policy.libDefinition.properties.metadata
    mode: policy.libDefinition.properties.mode
    parameters: policy.libDefinition.properties.parameters
    policyType: policy.libDefinition.properties.policyType
    policyRule: policy.libDefinition.properties.policyRule
  }
}]

