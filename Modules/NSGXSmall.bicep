param devspoke_NSG_name string
param NSG_location string
param parBastionOutboundSshRdpPorts array = [ '22', '3389' ]
param ProSpoke_NSG_name string
param evn string

resource devspoke_Nsg 'Microsoft.Network/networkSecurityGroups@2024-01-01'  = if (evn == 'dev') {
  name: devspoke_NSG_name
  location: NSG_location
  properties: {
    
      securityRules: [
        // Inbound Rules

        {
          name: 'Allow_AzureFW_to_dev_Subnet_Inbound'
          properties: {
            access: 'Allow'
            direction: 'Inbound'
            priority: 100
            sourceAddressPrefix: '10.10.254.0/24'
            destinationAddressPrefix: '10.2.0.0/16'
            protocol: 'Tcp'
            sourcePortRange: '*'
            destinationPortRange: '*'
          }
        }
        {
          name: 'AllowHttpsInbound'
          properties: {
            access: 'Allow'
            direction: 'Inbound'
            priority: 110
            sourceAddressPrefix: 'Internet'
            destinationAddressPrefix: '*'
            protocol: 'Tcp'
            sourcePortRange: '*'
            destinationPortRange: '443'
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
          name: 'AllowBastionHostCommunication'
          properties: {
            access: 'Allow'
            direction: 'Inbound'
            priority: 140
            sourceAddressPrefix: 'VirtualNetwork'
            destinationAddressPrefix: 'VirtualNetwork'
            protocol: 'Tcp'
            sourcePortRange: '*'
            destinationPortRanges: [
              '8080'
              '5701'
            ]
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
          name: 'Allow_AzureFW_to_dev_Subnet_Outbound'
          properties: {
            access: 'Allow'
            direction: 'outbound'
            priority: 100
            sourceAddressPrefix: '10.10.254.0/24'
            destinationAddressPrefix: '10.2.0.0/16'
            protocol: 'Tcp'
            sourcePortRange: '*'
            destinationPortRange: '*'
          }
        }
        {
          name: 'AllowSshRdpOutbound'
          properties: {
            access: 'Allow'
            direction: 'Outbound'
            priority: 110
            sourceAddressPrefix: '*'
            destinationAddressPrefix: 'VirtualNetwork'
            protocol: '*'
            sourcePortRange: '*'
            destinationPortRanges: parBastionOutboundSshRdpPorts
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
          name: 'AllowBastionCommunication'
          properties: {
            access: 'Allow'
            direction: 'Outbound'
            priority: 130
            sourceAddressPrefix: 'VirtualNetwork'
            destinationAddressPrefix: 'VirtualNetwork'
            protocol: '*'
            sourcePortRange: '*'
            destinationPortRanges: [
              '8080'
              '5701'
            ]
          }
        }
        {
          name: 'AllowGetSessionInformation'
          properties: {
            access: 'Allow'
            direction: 'Outbound'
            priority: 140
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
  


output devNsgId string = devspoke_Nsg.id


resource ProSpokeNsg 'Microsoft.Network/networkSecurityGroups@2024-01-01'  = if (evn == 'prod') {
  name: ProSpoke_NSG_name
  location: NSG_location
  properties: {
    
      securityRules: [
        // Inbound Rules
        {
          name: 'Allow_AzureFW_to_Prod_Subnet_Inbound'
          properties: {
            access: 'Allow'
            direction: 'Inbound'
            priority: 100
            sourceAddressPrefix: '10.10.254.0/24'
            destinationAddressPrefix: '10.1.0.0/24'
            protocol: 'Tcp'
            sourcePortRange: '*'
            destinationPortRange: '*'
          }
        }

        {
          name: 'AllowHttpsInbound'
          properties: {
            access: 'Allow'
            direction: 'Inbound'
            priority: 110
            sourceAddressPrefix: 'Internet'
            destinationAddressPrefix: '*'
            protocol: 'Tcp'
            sourcePortRange: '*'
            destinationPortRange: '443'
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
          name: 'AllowBastionHostCommunication'
          properties: {
            access: 'Allow'
            direction: 'Inbound'
            priority: 140
            sourceAddressPrefix: 'VirtualNetwork'
            destinationAddressPrefix: 'VirtualNetwork'
            protocol: 'Tcp'
            sourcePortRange: '*'
            destinationPortRanges: [
              '8080'
              '5701'
            ]
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
          name: 'Allow_AzureFW_to_Prod_Subnet_Outbound'
          properties: {
            access: 'Allow'
            direction: 'outbound'
            priority: 100
            sourceAddressPrefix: '10.10.254.0/24'
            destinationAddressPrefix: '10.1.0.0/24'
            protocol: 'Tcp'
            sourcePortRange: '*'
            destinationPortRange: '*'
          }
        }

        {
          name: 'AllowSshRdpOutbound'
          properties: {
            access: 'Allow'
            direction: 'Outbound'
            priority: 110
            sourceAddressPrefix: '*'
            destinationAddressPrefix: 'VirtualNetwork'
            protocol: '*'
            sourcePortRange: '*'
            destinationPortRanges: parBastionOutboundSshRdpPorts
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
          name: 'AllowBastionCommunication'
          properties: {
            access: 'Allow'
            direction: 'Outbound'
            priority: 130
            sourceAddressPrefix: 'VirtualNetwork'
            destinationAddressPrefix: 'VirtualNetwork'
            protocol: '*'
            sourcePortRange: '*'
            destinationPortRanges: [
              '8080'
              '5701'
            ]
          }
        }
        {
          name: 'AllowGetSessionInformation'
          properties: {
            access: 'Allow'
            direction: 'Outbound'
            priority: 140
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

output ProSpokeNsgId string = ProSpokeNsg.id


