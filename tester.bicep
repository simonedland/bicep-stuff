param location string = 'norwayeast'

var vnetname  = 'VNET_DEV_${uniqueString(resourceGroup().id)}'
var NSGname  = 'NSG_DEV_${uniqueString(resourceGroup().id)}'

@secure()
param adminUsername string
@secure()
param adminPassword string

module test 'modules/VMdeployer.bicep' = {
  dependsOn: [
    networkSecurityGroup
  ]
  name: 'VMdeployer'
  params: {
    numberOfVMs: 1
    adminUsername: adminUsername
    adminPassword: adminPassword
    location: location
    useexternalVnet: false
    externalVnetID: string(virtualNetwork.properties.subnets[0].id)
  }
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: vnetname
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'Subnet-1'
        properties: {
          addressPrefix: '10.0.0.0/24'
          networkSecurityGroup: {
            id: networkSecurityGroup.id
          }
        }
      }
    ]
  }
}

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2020-11-01' = {
  name: NSGname
  location: location
  properties: {
    securityRules: [
      {
        name: NSGname
        properties: {
          priority: 100
          protocol: 'Tcp'
          access: 'Allow'
          direction: 'Inbound'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '3389'
        }
      }
    ]
  }
}
