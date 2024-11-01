targetScope = 'resourceGroup'
@sys.description('Name for Azure Bastion Subnet NSG.')
param parAzBastionNsgName string = 'nsg-AzureBastionSubnet'

@sys.description('The Azure Region to deploy the resources into.')
param parLocation string = resourceGroup().location

@sys.description('Define outbound destination ports or ranges for SSH or RDP that you want to access from Azure Bastion.')
param parBastionOutboundSshRdpPorts array = [ '22', '3389' ]

@sys.description('Prefix value which will be prepended to all resource names.')
param parCompanyPrefix string = 'alz'

@sys.description('Name for Hub Network.')
param parHubNetworkName string = '${parCompanyPrefix}-hub-${parLocation}'

@sys.description('The IP address range for Hub Network.')
param parHubNetworkAddressPrefix string = '10.10.0.0/16'

@sys.description('Array of DNS Server IP addresses for VNet.')
param parDnsServerIps array = []

type subnetOptionsType = ({
  @description('Name of subnet.')
  name: string

  @description('IP-address range for subnet.')
  ipAddressRange: string

  @description('Id of Network Security Group to associate with subnet.')
  networkSecurityGroupId: string?

  @description('Id of Route Table to associate with subnet.')
  routeTableId: string?

  @description('Name of the delegation to create for the subnet.')
  delegation: string?
})[]

@sys.description('The name, IP address range, network security group, route table and delegation serviceName for each subnet in the virtual networks.')
param parSubnets subnetOptionsType = [
  {
    name: 'AzureBastionSubnet'
    ipAddressRange: '10.10.15.0/24'
    networkSecurityGroupId: ''
    routeTableId: ''
  }
  {
    name: 'GatewaySubnet'
    ipAddressRange: '10.10.252.0/24'
    networkSecurityGroupId: ''
    routeTableId: ''
  }
  {
    name: 'AzureFirewallSubnet'
    ipAddressRange: '10.10.254.0/24'
    networkSecurityGroupId: ''
    routeTableId: ''
  }
  {
    name: 'AzureFirewallManagementSubnet'
    ipAddressRange: '10.10.253.0/24'
    networkSecurityGroupId: ''
    routeTableId: ''
  }
]
var varSubnetMap = map(range(0, length(parSubnets)), i => {
  name: parSubnets[i].name
  ipAddressRange: parSubnets[i].ipAddressRange
  networkSecurityGroupId: parSubnets[i].?networkSecurityGroupId ?? ''
  routeTableId: parSubnets[i].?routeTableId ?? ''
  delegation: parSubnets[i].?delegation ?? ''
})

@sys.description('Switch to enable/disable Azure Bastion deployment.')
param parAzBastionEnabled bool = true

var varSubnetProperties = [for subnet in varSubnetMap: {
  name: subnet.name
  properties: {
    addressPrefix: subnet.ipAddressRange

    delegations: (empty(subnet.delegation)) ? null : [
      {
        name: subnet.delegation
        properties: {
          serviceName: subnet.delegation
        }
      }
    ]

    networkSecurityGroup: (subnet.name == 'AzureBastionSubnet' && parAzBastionEnabled) ? {
      id: '${resourceGroup().id}/providers/Microsoft.Network/networkSecurityGroups/${parAzBastionNsgName}'
    } : (empty(subnet.networkSecurityGroupId)) ? null : {
      id: subnet.networkSecurityGroupId
    }

    routeTable: (empty(subnet.routeTableId)) ? null : {
      id: subnet.routeTableId
    }
  }
}]

@sys.description('Switch to enable/disable DDoS Network Protection deployment.')
param parDdosEnabled bool = true

@sys.description('DDoS Plan Name.')
param parDdosPlanName string = '${parCompanyPrefix}-ddos-plan'

//DDos Protection plan will only be enabled if parDdosEnabled is true.
resource resDdosProtectionPlan 'Microsoft.Network/ddosProtectionPlans@2023-02-01' = if (parDdosEnabled) {
  name: parDdosPlanName
  location: parLocation
  
}

resource resHubVnet 'Microsoft.Network/virtualNetworks@2023-02-01' = {
  dependsOn: [
    resBastionNsg
  ]
  name: parHubNetworkName
  location: parLocation
  tags: {
    environment: 'test'
  }
  properties: {
    addressSpace: {
      addressPrefixes: [
        parHubNetworkAddressPrefix
      ]
    }
    dhcpOptions: {
      dnsServers: parDnsServerIps
    }
    subnets: varSubnetProperties
    enableDdosProtection: parDdosEnabled
    ddosProtectionPlan: (parDdosEnabled) ? {
      id: resDdosProtectionPlan.id
    } : null
  }
}

resource resBastionNsg 'Microsoft.Network/networkSecurityGroups@2024-01-01' = {
  name: parAzBastionNsgName
  location: parLocation
  

  properties: {
    securityRules: [
      // Inbound Rules
      {
        name: 'AllowHttpsInbound'
        properties: {
          access: 'Allow'
          direction: 'Inbound'
          priority: 120
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
          priority: 130
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
          priority: 140
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
          priority: 150
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
        name: 'AllowSshRdpOutbound'
        properties: {
          access: 'Allow'
          direction: 'Outbound'
          priority: 100
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
          priority: 110
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
          priority: 120
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

resource resAzureFirewallSubnetRef 'Microsoft.Network/virtualNetworks/subnets@2024-01-01' existing = if (parAzFirewallEnabled) {
  parent: resHubVnet
  name: 'AzureFirewallSubnet'
}

resource resAzureFirewallMgmtSubnetRef 'Microsoft.Network/virtualNetworks/subnets@2024-01-01' existing = if (parAzFirewallEnabled && (contains(map(parSubnets, subnets => subnets.name), 'AzureFirewallManagementSubnet'))) {
  parent: resHubVnet
  name: 'AzureFirewallManagementSubnet'
}

param parPublicIpSku string = 'Standard'
module modAzureFirewallPublicIp './publicIp.bicep' = if (parAzFirewallEnabled) {
  name: 'deploy-Firewall-Public-IP'
  params: {
    parLocation: parLocation
    parAvailabilityZones: parAzFirewallAvailabilityZones
    parPublicIpName: '${parPublicIpPrefix}${parAzFirewallName}${parPublicIpSuffix}'
    parPublicIpProperties: {
      publicIpAddressVersion: 'IPv4'
      publicIpAllocationMethod: 'Static'
    }
    parPublicIpSku: {
      name: parPublicIpSku
    }
    
  }
}
@sys.description('Optional Prefix for Public IPs. Include a succedent dash if required. Example: prefix-')
param parPublicIpPrefix string = ''

@sys.description('Optional Suffix for Public IPs. Include a preceding dash if required. Example: -suffix')
param parPublicIpSuffix string = '-PublicIP'

module modAzureFirewallMgmtPublicIp './publicIp.bicep' = if (parAzFirewallEnabled && (contains(map(parSubnets, subnets => subnets.name), 'AzureFirewallManagementSubnet'))) {
  name: 'deploy-Firewall-mgmt-Public-IP'
  params: {
    parLocation: parLocation
    parAvailabilityZones: parAzFirewallAvailabilityZones
    parPublicIpName: '${parPublicIpPrefix}${parAzFirewallName}-mgmt${parPublicIpSuffix}'
    parPublicIpProperties: {
      publicIpAddressVersion: 'IPv4'
      publicIpAllocationMethod: 'Static'
    }
    parPublicIpSku: {
      name: 'Standard'
    }
  
  }
}

@sys.description('Switch to enable/disable Azure Firewall deployment.')
param parAzFirewallEnabled bool = true

@sys.description('Set this to true for the initial deployment as one firewall policy is required. Set this to false in subsequent deployments if using custom policies.')
param parAzFirewallPoliciesEnabled bool = true

@sys.description('Azure Firewall Policies Name.')
param parAzFirewallPoliciesName string = '${parCompanyPrefix}-azfwpolicy-${parLocation}'

param parAzFirewallTier string = 'Basic'

@description('Private IP addresses/IP ranges to which traffic will not be SNAT.')
param parAzFirewallPoliciesPrivateRanges array = []

@description('The operation mode for automatically learning private ranges to not be SNAT.')
param parAzFirewallPoliciesAutoLearn string = 'Disabled'
@sys.description('Switch to enable/disable Azure Firewall DNS Proxy.')
param parAzFirewallDnsProxyEnabled bool = true

@sys.description('Array of custom DNS servers used by Azure Firewall')
param parAzFirewallDnsServers array = []
param parAzFirewallIntelMode string = 'Alert'


resource resFirewallPolicies 'Microsoft.Network/firewallPolicies@2024-01-01' = if (parAzFirewallEnabled && parAzFirewallPoliciesEnabled) {
  name: parAzFirewallPoliciesName
  location: parLocation
  
  properties: (parAzFirewallTier == 'Basic') ? {
    sku: {
      tier: parAzFirewallTier
    }
    snat: !empty(parAzFirewallPoliciesPrivateRanges)
    ? {
      autoLearnPrivateRanges: parAzFirewallPoliciesAutoLearn
      privateRanges: parAzFirewallPoliciesPrivateRanges
      }
    : null
    threatIntelMode: 'Alert'
  } : {
    dnsSettings: {
      enableProxy: parAzFirewallDnsProxyEnabled
      servers: parAzFirewallDnsServers
    }
    sku: {
      tier: parAzFirewallTier
    }
    threatIntelMode: parAzFirewallIntelMode
  }
}

@sys.description('Azure Firewall Name.')
param parAzFirewallName string = '${parCompanyPrefix}-azfw-${parLocation}'

@sys.description('Availability Zones to deploy the Azure Firewall across. Region must support Availability Zones to use. If it does not then leave empty.')
param parAzFirewallAvailabilityZones array = []

var varAzFirewallUseCustomPublicIps = length(parAzFirewallCustomPublicIps) > 0
@sys.description('Optional List of Custom Public IPs, which are assigned to firewalls ipConfigurations.')
param parAzFirewallCustomPublicIps array = []

resource resAzureFirewall 'Microsoft.Network/azureFirewalls@2024-01-01' = if (parAzFirewallEnabled) {
  
  name: parAzFirewallName
  location: parLocation
 
  zones: (!empty(parAzFirewallAvailabilityZones) ? parAzFirewallAvailabilityZones : [])
  properties: parAzFirewallTier == 'Basic' ? {
    ipConfigurations: varAzFirewallUseCustomPublicIps
     ? map(parAzFirewallCustomPublicIps, ip =>
       {
        name: 'ipconfig${uniqueString(ip)}'
        properties: ip == parAzFirewallCustomPublicIps[0]
         ? {
          subnet: {
            id: resAzureFirewallSubnetRef.id
          }
          publicIPAddress: {
            id: parAzFirewallEnabled ? ip : ''
          }
        }
         : {
          publicIPAddress: {
            id: parAzFirewallEnabled ? ip : ''
          }
        }
      })
     : [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: resAzureFirewallSubnetRef.id
          }
          publicIPAddress: {
            id: parAzFirewallEnabled ? modAzureFirewallPublicIp.outputs.outPublicIpId : ''
          }
        }
      }
    ]
    managementIpConfiguration: {
      name: 'mgmtIpConfig'
      properties: {
        publicIPAddress: {
          id: parAzFirewallEnabled ? modAzureFirewallMgmtPublicIp.outputs.outPublicIpId : ''
        }
        subnet: {
          id: resAzureFirewallMgmtSubnetRef.id
        }
      }
    }
    sku: {
      name: 'AZFW_VNet'
      tier: parAzFirewallTier
    }
    firewallPolicy: {
      id: resFirewallPolicies.id
    }
  } : {
    ipConfigurations: varAzFirewallUseCustomPublicIps
     ? map(parAzFirewallCustomPublicIps, ip =>
       {
        name: 'ipconfig${uniqueString(ip)}'
        properties: ip == parAzFirewallCustomPublicIps[0]
         ? {
          subnet: {
            id: resAzureFirewallSubnetRef.id
          }
          publicIPAddress: {
            id: parAzFirewallEnabled ? ip : ''
          }
        }
         : {
          publicIPAddress: {
            id: parAzFirewallEnabled ? ip : ''
          }
        }
      })
     : [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: resAzureFirewallSubnetRef.id
          }
          publicIPAddress: {
            id: parAzFirewallEnabled ? modAzureFirewallPublicIp.outputs.outPublicIpId : ''
          }
        }
      }
    ]
    sku: {
      name: 'AZFW_VNet'
      tier: parAzFirewallTier
    }
    firewallPolicy: {
      id: resFirewallPolicies.id
    }
  }
}

@sys.description('Name of Route table to create for the default route of Hub.')
param parHubRouteTableName string = '${parCompanyPrefix}-hub-routetable'

@sys.description('Switch to enable/disable BGP Propagation on route table.')
param parDisableBgpRoutePropagation bool = false

//If Azure Firewall is enabled we will deploy a RouteTable to redirect Traffic to the Firewall.
resource resHubRouteTable 'Microsoft.Network/routeTables@2024-01-01' = if (parAzFirewallEnabled) {
  name: parHubRouteTableName
  location: parLocation
  
  properties: {
    routes: [
      {
        name: 'udr-default-azfw'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: parAzFirewallEnabled ? resAzureFirewall.properties.ipConfigurations[0].properties.privateIPAddress : ''
        }
      }
    ]
    disableBgpRoutePropagation: parDisableBgpRoutePropagation
  }
}
