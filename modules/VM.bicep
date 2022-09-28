param NICid string = 'null'
param location string = 'westus3'
param VMname string = 'VM1'


@secure()
param uname string
@secure()
param password string
@secure()
param passwordConfirm string

var passwordcheck = password == passwordConfirm


resource windowsVM 'Microsoft.Compute/virtualMachines@2020-12-01' = if (passwordcheck){
  name: VMname
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_D2s_v3'
    }
    osProfile: {
      computerName: 'computerName'
      adminUsername: uname
      adminPassword: password
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsDesktop'
        offer: 'Windows-11'
        sku: 'win11-21h2-pro'
        version: 'latest'
      }
      osDisk: {
        name: 'osdisk'
        caching: 'ReadWrite'
        createOption: 'FromImage'
      }
    }
    networkProfile: NICid != 'null' ? {
      networkInterfaces: [
        {
          id: NICid
        }
      ]
    } : null
  }
}
