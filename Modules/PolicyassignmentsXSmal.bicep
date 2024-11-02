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


// {
//    Name: 'Audit-RDP-From-Internet'
//     displayName: 'RDP should not be allowed from the Internet'
//     description: 'This policy denies the creation of a security rule that allows RDP traffic from the Internet. RDP should be restricted to specific IP ranges.'
//     enforcementMode: 'Default'
//     source: 'https://github.com/Azure/Enterprise-Scale/'
//     policyDefinitionId: '/subscriptions/mgmtSubID/providers/Microsoft.Authorization/policyDefinitions/Deny-RDP-From-Internet'
//   }
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

param assignmentName string = 'CISMicrosoftAzureFoundationsBenchmarkAssignment'
param policySetDefinitionId string = '/providers/Microsoft.Authorization/policySetDefinitions/06f19060-9e68-4070-92ca-f15cc126059e'
param parameters object = {
  maximumDaysToRotate: {
    value: 90
  }
}

resource policyAssignmentCIS 'Microsoft.Authorization/policyAssignments@2021-06-01' = {
  name: assignmentName

  properties: {
    displayName: 'CIS Microsoft Azure Foundations Benchmark v2.0.0 Assignment'
    policyDefinitionId: policySetDefinitionId
    parameters: parameters
    enforcementMode: 'Default'
  }
}
