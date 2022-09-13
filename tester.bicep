param location string = 'westus3'

param extVNET bool = true

var vnetname  = 'VNET_ext_${uniqueString(resourceGroup().id)}'
var NSGname  = 'NSG_ext_${uniqueString(resourceGroup().id)}'

@secure()
param adminUsername string
@secure()
param adminPassword string

module test 'modules/VMdeployer.bicep' = {
  dependsOn: [
    exnetworkSecurityGroup
  ]
  name: 'VMdeployer'
  params: {
    numberOfVMs: 1
    adminUsername: adminUsername
    adminPassword: adminPassword
    location: location
    useexternalVnet: extVNET
    externalVnetID: string(exvirtualNetwork.properties.subnets[0].id)
  }
}

resource exvirtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' = if (extVNET) {
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
            id: exnetworkSecurityGroup.id
          }
        }
      }
    ]
  }
}

resource exnetworkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2020-11-01' = if (extVNET) {
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
