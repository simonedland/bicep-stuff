@description('The name of the service to be used for the service discovery')
param vnetname string= 'vnet1'

@description('The location of deployment')
param location string = 'westus3'

@description('The ip prefix to be used for the service ip only where the octets are devided by a dot')
param addressPrefix string = '10.0.0.0' //currently only supports one adress block

@description('The CIDR of the subnet default is 16')
param cidrPrefixes string = '16'

//var octets = split(addressPrefix, '.') //dont know if i am going to use this, but it is handy to have


@description('The array of subbnet values and variables')
param subnets array = [
  {
      name: 'subnet1'
      minimumnumberofips: 254
      adressPrefix: '10.0.0.0'
  }
  {
      name: 'subnet2'
      minimumnumberofips: 126
      adressPrefix: '10.0.1.0'
}]

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: vnetname
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '${addressPrefix}/${cidrPrefixes}'
      ]
    }
    subnets:[for subbnet in subnets :{
        name: subbnet.name
        properties: { //the calculation of CIDR under might be wrong, but it is just a proof of consept
          addressPrefix: '${subbnet.adressPrefix}/${subbnet.minimumnumberofips > 127 ? 24 : subbnet.minimumnumberofips > 63 ? 25 : subbnet.minimumnumberofips > 31 ? 26 : subbnet.minimumnumberofips > 15 ? 27 : subbnet.minimumnumberofips > 7 ? 28 : subbnet.minimumnumberofips > 3 ? 29 : subbnet.minimumnumberofips > 1 ? 30 : 31}'
        }
      }]
  }
}
