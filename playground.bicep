param location string = 'norwayeast'

@description('allowed : dev, test, prod, live')
@allowed([
  'dev'
  'test'
  'prod'
  'live'
])
param enviromenttype string = 'dev'

var test = [
  {
    name:'test1'
    value:'test1'
  }
  {
    name:'test2'
    value:'test2'
  }
  {
    name:'test3'
    value:'test3'
  }
]

resource appServicePlan 'Microsoft.Web/serverfarms@2020-12-01' = [for (plan, index) in test: {
  name: '${plan.name}_${enviromenttype}'
  location: location
  sku: {
    name: 'F1'
    capacity: 1
  }
}]
