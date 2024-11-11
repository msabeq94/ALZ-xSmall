param NSG_name string
param NSG_location string



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
            sourceAddressPrefix: '10.10.254.0/24'
            destinationAddressPrefix: '*'
            protocol: 'Tcp'
            sourcePortRange: '*'
            destinationPortRange: '*'
          }
        }
        {
          name: 'AllowHttp_HttpsInbound'
          properties: {
            access: 'Allow'
            direction: 'Inbound'
            priority: 110
            sourceAddressPrefix: 'Internet'
            destinationAddressPrefix: '*'
            protocol: '*'
            sourcePortRange: '*'
            destinationPortRanges: [
              '443'
              '80'
            ]
          }
        }
        {
          name: 'AllowGatewayManagerInbound'
          properties: {
            access: 'Allow'
            direction: 'Inbound'
            priority: 120
            sourceAddressPrefix: 'GatewayManager'
            destinationAddressPrefix: '*'
            protocol: 'Tcp'
            sourcePortRange: '*'
            destinationPortRange: '443'
          }
        }
        {
          name: 'AllowAzureLoadBalancerInbound'
          properties: {
            access: 'Allow'
            direction: 'Inbound'
            priority: 130
            sourceAddressPrefix: 'AzureLoadBalancer'
            destinationAddressPrefix: '*'
            protocol: 'Tcp'
            sourcePortRange: '*'
            destinationPortRange: '443'
          }
        }
        {
          name: 'AllowSSHCommunication'
          properties: {
            access: 'Allow'
            direction: 'Inbound'
            priority: 140
            sourceAddressPrefix: '*'
            destinationAddressPrefix: '*'
            protocol: 'Tcp'
            sourcePortRange: '*'
            destinationPortRanges:'22'
          }
        }
        {
          name: 'AllowRDPCommunication'
          properties: {
            access: 'Allow'
            direction: 'Inbound'
            priority: 150
            sourceAddressPrefix: '*'
            destinationAddressPrefix: '*'
            protocol: 'Tcp'
            sourcePortRange: '*'
            destinationPortRanges: '3389'
          }
        }

        {
          name: 'DenyAllInbound'
          properties: {
            access: 'Deny'
            direction: 'Inbound'
            priority: 4096
            sourceAddressPrefix: '*'
            destinationAddressPrefix: '*'
            protocol: '*'
            sourcePortRange: '*'
            destinationPortRange: '*'
          }
        }
        // Outbound Rules
        {
          name: 'Allow_Subnet_to_AzureFW_Outbound'
          properties: {
            access: 'Allow'
            direction: 'outbound'
            priority: 100
            sourceAddressPrefix: '*'
            destinationAddressPrefix: '10.10.254.0/24'
            protocol: 'Tcp'
            sourcePortRange: '*'
            destinationPortRange: '*'
          }
        }
       
        {
          name: 'AllowAzureCloudOutbound'
          properties: {
            access: 'Allow'
            direction: 'Outbound'
            priority: 120
            sourceAddressPrefix: '*'
            destinationAddressPrefix: 'AzureCloud'
            protocol: 'Tcp'
            sourcePortRange: '*'
            destinationPortRange: '443'
          }
        }
      
        {
          name: 'AllowGetSessionInformation'
          properties: {
            access: 'Allow'
            direction: 'Outbound'
            priority: 130
            sourceAddressPrefix: '*'
            destinationAddressPrefix: 'Internet'
            protocol: '*'
            sourcePortRange: '*'
            destinationPortRange: '80'
          }
        }
        {
          name: 'DenyAllOutbound'
          properties: {
            access: 'Deny'
            direction: 'Outbound'
            priority: 4096
            sourceAddressPrefix: '*'
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




