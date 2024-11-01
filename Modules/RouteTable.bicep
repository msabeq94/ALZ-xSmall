param HubRouteTableName string
param RTLocation string
param FWIP string
param parDisableBgpRoutePropagation bool = false

resource resHubRouteTable 'Microsoft.Network/routeTables@2024-01-01' =  {
  name: HubRouteTableName
  location: RTLocation
  
  properties: {
    routes: [
      {
        name: 'udr-default-azfw'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: FWIP
        }
      }
    ]
    disableBgpRoutePropagation: parDisableBgpRoutePropagation
  }
}

output routtableID string = resHubRouteTable.id
