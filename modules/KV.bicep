param location string = resourceGroup().location 
var tenantId = subscription().tenantId
var objektid = '367030a5-218c-47d6-8765-53c0e63f2b30'
var keyvaultname  = 'kv-${uniqueString(resourceGroup().id)}-001'

param secrets array = [{
  name: 'test1'
  key: 'test1'
}
{
  name: 'test2'
  key: 'test2'
}
]

resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' = {
  name: keyvaultname
  location: location
  properties: {
    sku: {
      name: 'standard'
      family: 'A'
    }
    tenantId: tenantId
    accessPolicies: [
      {
        tenantId: tenantId
        objectId: objektid
        permissions: {
          keys: [
            'get'
            'list'
          ]
          secrets: [
            'list'
            'get'
            'set'
          ]
        }
      }
    ]
  }
}

resource keyVaultSecret 'Microsoft.KeyVault/vaults/secrets@2022-07-01' = [for i in range(0,length(secrets)) : {
  parent: keyVault
  name: '${keyVault.name}-${secrets[i].name}'
  properties: {
    value: secrets[i].value
  }
}]
output keyvaultsecrets array = [keyVaultSecret[0], keyVaultSecret[1], keyVaultSecret[2]]
output keyvaultname string = keyVault.name
