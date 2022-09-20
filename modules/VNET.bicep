param location string = 'westus3'
param vnetname string = 'vnet'
param numberofsubnets int = 1
param minimumnumberofips int = 1



var prefix = minimumnumberofips > 127 ? 24 : minimumnumberofips > 63 ? 25 : minimumnumberofips > 31 ? 26 : minimumnumberofips > 15 ? 27 : minimumnumberofips > 7 ? 28 : minimumnumberofips > 3 ? 29 : minimumnumberofips > 1 ? 30 : 31

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: vnetname
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets:[for i in range(0, numberofsubnets) :{
        name: 'subnet${i}'
        properties: {
          addressPrefix: '10.0.${i}.0/${prefix}'
          networkSecurityGroup: {
            id: networkSecurityGroup.id
          }
        }
      }]
  }
}
