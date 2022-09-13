/*
todo
add a param for seperating the VM in difrent subbnets
add a param for adding a public ip to the VM
add a param for subnet size
add a param for using eksisting NSG
*/



param location string = 'westus3'
param useexternalVnet bool = false
param externalVnetID string = ''

var VMName  = 'VM_${uniqueString(resourceGroup().id)}'
var nicname  = 'NIC_${uniqueString(resourceGroup().id)}'
var vnetname  = 'VNET_${uniqueString(resourceGroup().id)}'
var NSGname  = 'NSG_${uniqueString(resourceGroup().id)}'
var publicIPname  = 'PUBIP_${uniqueString(resourceGroup().id)}'
var osDiskName  = 'OSDisk_${uniqueString(resourceGroup().id)}'
@secure()
param adminUsername string
@secure()
param adminPassword string

param numberOfVMs int = 2

resource windowsVM 'Microsoft.Compute/virtualMachines@2020-12-01' = [for i in range(0,numberOfVMs):{
  name: '${VMName}_${i}'
  location: location
  dependsOn: [
    networkInterface
  ]
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_D2s_v3'
    }
    osProfile: {
      computerName: 'computerName'
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsDesktop'
        offer: 'Windows-11'
        sku: 'win11-21h2-pro'
        version: 'latest'
      }
      osDisk: {
        name: '${osDiskName}_${i}'
        caching: 'ReadWrite'
        createOption: 'FromImage'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: resourceId('Microsoft.Network/networkInterfaces', '${nicname}_${i}')
        }
      ]
    }
  }
}]

resource networkInterface 'Microsoft.Network/networkInterfaces@2020-11-01' = [for i in range(0,numberOfVMs):{
  name: '${nicname}_${i}'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: nicname
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIP[i].id
          }
          subnet: {
            id: useexternalVnet == true ? string(externalVnetID) : virtualNetwork.properties.subnets[0].id
          }
        }
      }
    ]
  }
}]

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' =  if (useexternalVnet == false){
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

resource publicIP 'Microsoft.Network/publicIPAddresses@2020-11-01' = [for i in range(0,numberOfVMs): {
  name: '${publicIPname}_${i}'
  location: location
  properties: {
    publicIPAllocationMethod: 'Dynamic'
  }
}]

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2020-11-01' =  if (useexternalVnet == false){
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
