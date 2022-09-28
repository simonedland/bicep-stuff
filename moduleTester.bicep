param location string = 'westus3'
@secure()
param password string
@secure()
param passwordconfirm string


module VNET 'modules/VNET.bicep' = {
  name: 'VNET'
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
  params: {
    location: location
  }
}

module NIC 'modules/NIC.bicep' = {
  name: 'NIC'
  params: {
    location: location
    subnetId: VNET.outputs.virtualNetworkName.properties.subnets[0].id
    publicIPid: publicIP.outputs.publicIPid
  }
}

module publicIP 'modules/pubIP.bicep' = {
  name: 'publicIP'
  params: {
    location: location
  }
}

module VM 'modules/VM.bicep' = {
  name: 'VM'
  dependsOn: [
    VNET
    NSG
    NIC
    publicIP
  ]
  params: {
    location: location
    NICid: NIC.outputs.NICid
    password: password
    passwordConfirm: passwordconfirm
    uname: 'Toor'
  }
}
