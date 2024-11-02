// param parPolicyAssignmentIdentityType string = 'None'
// var varPolicyIdentity = parPolicyAssignmentIdentityType == 'SystemAssigned' ? 'SystemAssigned' : 'None'
var varCustomPolicyassignmentsAuditDenyArrayXSmall = [
 
  {
    name: 'Audit-Subnet-Without-Nsg'
    displayName: 'Subnets should have a Network Security Group'
    description: 'This policy denies the creation of a subnet without a Network Security Group. NSG help to protect traffic across subnet-level.'
    enforcementMode: 'Default'
    source: 'https://github.com/Azure/Enterprise-Scale/'
    policyDefinitionId: '/subscriptions/mgmtSubID/providers/Microsoft.Authorization/policyDefinitions/Deny-Subnet-Without-Nsg'

  }
{
    name: 'Audit-Subnet-Without-Udr'
    displayName: 'Subnets should have a User Defined Route'
    description: 'This policy denies the creation of a subnet without a User Defined Route. UDRs help to control routing of traffic within a subnet.'
    enforcementMode: 'Default'
    source: 'https://github.com/Azure/Enterprise-Scale/'
    policyDefinitionId: '/subscriptions/mgmtSubID/providers/Microsoft.Authorization/policyDefinitions/Deny-Subnet-Without-Udr'
}
{
   Name: 'Audit-RDP-From-Internet'
    displayName: 'RDP should not be allowed from the Internet'
    description: 'This policy denies the creation of a security rule that allows RDP traffic from the Internet. RDP should be restricted to specific IP ranges.'
    enforcementMode: 'Default'
    source: 'https://github.com/Azure/Enterprise-Scale/'
    policyDefinitionId: '/subscriptions/mgmtSubID/providers/Microsoft.Authorization/policyDefinitions/Deny-RDP-From-Internet'
  }
]
resource assignmentAuditDeny 'Microsoft.Authorization/policyAssignments@2020-09-01' = [for assignmentAD in varCustomPolicyassignmentsAuditDenyArrayXSmall: {
  name: assignmentAD.name
  properties: {
    displayName: assignmentAD.displayName
    description: assignmentAD.description
    enforcementMode: assignmentAD.enforcementMode
    metadata: {
      source: assignmentAD.source
      version: '0.1.0'
    }
    policyDefinitionId: assignmentAD.policyDefinitionId
  }
  
}
]


// var varCustomPolicyassignmentsAuditDeployXSmall = [
 
//   {
//     name: 'Deploy-Custom-Route-Table'
//     displayName: 'Deploy a route table with specific user defined routes'
//     description: 'Deploys a route table with specific user defined routes when one does not exist. The route table deployed by the policy must be manually associated to subnet(s)'
//     enforcementMode: 'Default'
//     source: 'https://github.com/Azure/Enterprise-Scale/'
//     policyDefinitionId: '/subscriptions/mgmtSubID/providers/Microsoft.Authorization/policyDefinitions/Deploy-Custom-Route-Table'
//   }
//   {
//     name: 'Deploy-DDoSProtection'
//     displayName: 'Deploy an Azure DDoS Network Protection'
//     description: 'Deploys an Azure DDoS Network Protection'
//     enforcementMode: 'Default'
//     source: 'https://github.com/Azure/Enterprise-Scale/'
//     policyDefinitionId: '/subscriptions/mgmtSubID/providers/Microsoft.Authorization/policyDefinitions/Deploy-DDoSProtection'
//   }
//   {
//     name: 'Deploy-FirewallPolicy'
//     displayName: 'Deploy Azure Firewall Manager policy in the subscription'
//     description: 'Deploys Azure Firewall Manager policy in subscription where the policy is assigned.'
//     enforcementMode: 'Default'
//     source: 'https://github.com/Azure/Enterprise-Scale/'
//     policyDefinitionId: '/subscriptions/mgmtSubID/providers/Microsoft.Authorization/policyDefinitions/Deploy-FirewallPolicy'
//   }
//   {
//     name: 'Deploy-VNET-HubSpoke'
//     displayName: 'Deploy Virtual Network with peering to the hub'
//     description: 'This policy deploys virtual network and peer to the hub'
//     enforcementMode: 'Default'
//     source: 'https://github.com/Azure/Enterprise-Scale/'
//     policyDefinitionId: '/subscriptions/mgmtSubID/providers/Microsoft.Authorization/policyDefinitions/Deploy-VNET-HubSpoke'
//   }


// ]
// resource assignmentDeploy 'Microsoft.Authorization/policyAssignments@2020-09-01' = [for assignmentDY in varCustomPolicyassignmentsAuditDeployXSmall: {
//   name: assignmentDY.name
//   properties: {
//     displayName: assignmentDY.displayName
//     description: assignmentDY.description
//     enforcementMode: assignmentDY.enforcementMode
//     metadata: {
//       source: assignmentDY.source
//       version: '0.1.0'
//     }
//     policyDefinitionId: assignmentDY.policyDefinitionId
//   }
//   identity: {
//     type: varPolicyIdentity
//   }
 
// }

// ]
