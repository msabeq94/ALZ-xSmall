targetScope = 'subscription'
var varCustomPolicyDefinitionsArrayXSmall = [
  // {
  //   name: 'Audit-RDP-From-Internet'
  //   libDefinition: loadJsonContent('policy_definitions/Audit-RDP-From-Internet.json')
  // }
  {
    name: 'Deploy-FirewallPolicy'
    libDefinition: loadJsonContent('policy_definitions/Deploy-FirewallPolicy.json')
  }
  {
    name: 'Audit-Subnet-Without-Nsg'
    libDefinition: loadJsonContent('policy_definitions/Audit-Subnet-Without-Nsg.json')
  }
  
  {
    name: 'Audit-Subnet-Without-Udr'
    libDefinition: loadJsonContent('policy_definitions/Audit-Subnet-Without-Udr.json')
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

