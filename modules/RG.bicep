targetScope='subscription'

param name string
param location string

resource newRG 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: name
  location: location
}
output resourceGroupName string = newRG.name
