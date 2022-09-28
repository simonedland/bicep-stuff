param NICname string = 'eth0'
param location string = 'westus3'
param subnetId string = 'null'
param publicIPid string = 'null'


resource networkInterface 'Microsoft.Network/networkInterfaces@2020-11-01' = {
  name: NICname
  location: location
  properties: {
    ipConfigurations: [
      {
        name: NICname
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: publicIPid != 'null' ? {
            id: publicIPid
          } : null
          subnet: subnetId != 'null' ? {
            id: subnetId
          } : null
        }
      }
    ]
  }
}

output NICid string = networkInterface.id
output NICobj object = networkInterface
