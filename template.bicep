param networkSecurityGroups_MS_Terraform_nsg_name string = 'MS-Terraform-nsg'

resource networkSecurityGroups_MS_Terraform_nsg_name_resource 'Microsoft.Network/networkSecurityGroups@2024-01-01' = {
  name: networkSecurityGroups_MS_Terraform_nsg_name
  location: 'eastus'
  tags: {
    'vf-core-cloud-monitoring': 'true'
  }
  properties: {
    securityRules: [
      {
        name: 'SSH'
        id: networkSecurityGroups_MS_Terraform_nsg_name_SSH.id
        type: 'Microsoft.Network/networkSecurityGroups/securityRules'
        properties: {
          protocol: 'TCP'
          sourcePortRange: '*'
          destinationPortRange: '22'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 300
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
      {
        name: 'AllowAnyCu'
        id: networkSecurityGroups_MS_Terraform_nsg_name_AllowAnyCu.id
        type: 'Microsoft.Network/networkSecurityGroups/securityRules'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 310
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: [
            '8080'
            '22'
          ]
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
    ]
  }
}

resource networkSecurityGroups_MS_Terraform_nsg_name_AllowAnyCu 'Microsoft.Network/networkSecurityGroups/securityRules@2024-01-01' = {
  name: '${networkSecurityGroups_MS_Terraform_nsg_name}/AllowAnyCu'
  properties: {
    protocol: '*'
    sourcePortRange: '*'
    sourceAddressPrefix: '*'
    destinationAddressPrefix: '*'
    access: 'Allow'
    priority: 310
    direction: 'Inbound'
    sourcePortRanges: []
    destinationPortRanges: [
      '8080'
      '22'
    ]
    sourceAddressPrefixes: []
    destinationAddressPrefixes: []
  }
  dependsOn: [
    networkSecurityGroups_MS_Terraform_nsg_name_resource
  ]
}

resource networkSecurityGroups_MS_Terraform_nsg_name_SSH 'Microsoft.Network/networkSecurityGroups/securityRules@2024-01-01' = {
  name: '${networkSecurityGroups_MS_Terraform_nsg_name}/SSH'
  properties: {
    protocol: 'TCP'
    sourcePortRange: '*'
    destinationPortRange: '22'
    sourceAddressPrefix: '*'
    destinationAddressPrefix: '*'
    access: 'Allow'
    priority: 300
    direction: 'Inbound'
    sourcePortRanges: []
    destinationPortRanges: []
    sourceAddressPrefixes: []
    destinationAddressPrefixes: []
  }
  dependsOn: [
    networkSecurityGroups_MS_Terraform_nsg_name_resource
  ]
}