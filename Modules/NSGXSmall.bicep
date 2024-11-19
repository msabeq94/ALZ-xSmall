param NSG_name string
param NSG_location string
param NSG_addressPrefix_FWIP string



resource Nsg 'Microsoft.Network/networkSecurityGroups@2024-01-01'  =  {
  name: NSG_name
  location: NSG_location
  properties: {
    
      securityRules: [
        // Inbound Rules

        {
          name: 'Allow_AzureFW_to_Subnet_Inbound'
          properties: {
            access: 'Allow'
            direction: 'Inbound'
            priority: 100
            sourceAddressPrefix: NSG_addressPrefix_FWIP
            destinationAddressPrefix: '*'
            protocol: '*'
            sourcePortRange: '*'
            destinationPortRange: '*'
          }
        }
      ]
  }

}
  


output NsgId string = Nsg.id




