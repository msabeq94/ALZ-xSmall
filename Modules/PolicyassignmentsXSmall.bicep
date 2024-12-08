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
  
}]
