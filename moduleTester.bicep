param location string = 'norwayeast'
@secure()
param password string
@secure()
param passwordconfirm string

// Create a new resource group
// SSH key in keyvault
// scaling set
// logic app
//beter key vault

module resGroup './modules/RG.bicep' = {
  scope: subscription()
  name: 'rg-${location}'
  params: {
    name: 'rg-${location}'
    location: location
  }
}

var secrets = [
    {
      name: 'password'
      value: password
    }
    {
      name: 'passwordconfirm'
      value: passwordconfirm
    }
    {
      name: 'uname'
      value: 'Toor'
    }
]


//might want to transpose to make it two objekts - one for name and one for value
//this is bechause i then can make the names and values secure
//make a param in to two objekts, then set secure on them...
module KV 'modules/KV.bicep' = {
  name: 'KV'
  scope: resourceGroup(resGroup.name)
  params: {
    location: location
    secrets: secrets
  }
}

resource KeyVault 'Microsoft.KeyVault/vaults@2022-07-01' existing = {
  scope: resourceGroup(resGroup.name)
  name: KV.outputs.keyvaultname
}



module VNET 'modules/VNET.bicep' = {
  name: 'VNET'
  scope: resourceGroup(resGroup.name)
  params: {
    vnetname: 'VNET1'
    location: location
    addressPrefix: '10.0.0.0'
    cidrPrefixes:'16'
    NSGid: NSG.outputs.NSGid
    subnets: [
      {
        name: 'subnet1'
        minimumnumberofips: 254
        addressPrefix: '10.0.0.0'
    }]
  }
}

module NSG 'modules/NSG.bicep' = {
  name: 'NSG'
  scope: resourceGroup(resGroup.name)
  params: {
    location: location
  }
}

module NIC 'modules/NIC.bicep' = {
  name: 'NIC'
  scope: resourceGroup(resGroup.name)
  params: {
    location: location
    subnetId: VNET.outputs.virtualNetworkName.properties.subnets[0].id
    publicIPid: publicIP.outputs.publicIPid
  }
}

module publicIP 'modules/pubIP.bicep' = {
  name: 'publicIP'
  scope: resourceGroup(resGroup.name)
  params: {
    location: location
  }
}

module VM 'modules/VM.bicep' = {
  name: 'VM'
  scope: resourceGroup(resGroup.name)
  dependsOn: [
    VNET
    NSG
    NIC
    publicIP
  ]
  params: {
    vmSize: 'Standard_B2s'
    location: location
    NICid: NIC.outputs.NICid
    password: KeyVault.getSecret('${KeyVault.name}-password') //'Toor1234567890'
    passwordConfirm: KeyVault.getSecret('${KeyVault.name}-passwordconfirm')
    uname: KeyVault.getSecret('${KeyVault.name}-uname')
    uselinux: true
  }
}
