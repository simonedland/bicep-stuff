param location string = resourceGroup().location 
var tenantId = subscription().tenantId
var objektid = '367030a5-218c-47d6-8765-53c0e63f2b30'
var keyvaultname  = 'kv-${uniqueString(resourceGroup().id)}-001'


@description('exspects a list of secrets that should have key valye for both the name and key')
param secrets array = [
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
    enabledForTemplateDeployment: true
  }
}

resource keyVaultSecret 'Microsoft.KeyVault/vaults/secrets@2022-07-01' = [for i in range(0,length(secrets)) : {
  parent: keyVault
  name: '${keyVault.name}-${secrets[i].name}'
  properties: {
    value: secrets[i].value
  }
}]
output keyvaultname string = keyVault.name
