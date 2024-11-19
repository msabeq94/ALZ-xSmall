param parLocation string = resourceGroup().location
param parAzFirewallTier string = 'Basic'
param parAzFirewallPoliciesPrivateRanges array = []
param parAzFirewallPoliciesAutoLearn string = 'Disabled'
param parAzFirewallDnsProxyEnabled bool = true
param parAzFirewallDnsServers array = []
param parAzFirewallIntelMode string = 'Alert'
param parAzFirewallName string = 'azfw-${parLocation}'
param parAzFirewallAvailabilityZones array = []
param parAzFirewallCustomPublicIps array = []
var varAzFirewallUseCustomPublicIps = length(parAzFirewallCustomPublicIps) > 0

resource resFirewallPolicies 'Microsoft.Network/firewallPolicies@2024-01-01' =  {
  name: 'azfwpolicy'
  location: parLocation
  
  properties: {
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


// AzureFirewallSubnet is required to deploy Azure Firewall . This subnet must exist in the parsubnets array if you deploy.
// There is a minimum subnet requirement of /26 prefix.
resource resAzureFirewall 'Microsoft.Network/azureFirewalls@2024-01-01' =  {
 
  name: parAzFirewallName
  location: parLocation
  
  zones: (!empty(parAzFirewallAvailabilityZones) ? parAzFirewallAvailabilityZones : [])
  properties:  {
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
