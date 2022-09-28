param name string = 'pubip1'
param location string = 'westus3'

resource publicIP 'Microsoft.Network/publicIPAddresses@2020-11-01' = {
  name: name
  location: location
  properties: {
    publicIPAllocationMethod: 'Dynamic'
  }
}

output publicIPid string = publicIP.id
