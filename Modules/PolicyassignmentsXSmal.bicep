var varCustomPolicyassignmentsAuditDenyArrayXSmall = [
 
  {
    name: 'Audit-Subnet-Without-Nsg'
    displayName: 'Subnets should have a Network Security Group'
    description: 'This policy denies the creation of a subnet without a Network Security Group. NSG help to protect traffic across subnet-level.'
    enforcementMode: 'Default'
    source: 'https://github.com/Azure/Enterprise-Scale/'
    policyDefinitionId: '/subscriptions/f881605a-7628-40a3-adb7-59bd2e6a9dcd/providers/Microsoft.Authorization/policyDefinitions/Deny-Subnet-Without-Nsg'

  }

]

resource assignmentAuditDeny 'Microsoft.Authorization/policyAssignments@2020-09-01' = [for assignment in varCustomPolicyassignmentsAuditDenyArrayXSmall: {
  name: assignment.name
  properties: {
    displayName: assignment.displayName
    description: assignment.description
    enforcementMode: assignment.enforcementMode
    metadata: {
      source: assignment.source
      version: '0.1.0'
    }
    policyDefinitionId: assignment.policyDefinitionId
  }
  
}
]
