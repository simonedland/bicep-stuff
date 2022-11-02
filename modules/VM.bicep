param NICid string = 'null'
param location string = 'westus3'
param VMname string = 'VM1'
param vmSize string = 'Standard_D2s_v3'
param uselinux bool = false
param windowsOffer string = 'Windows-11'
param windowsSku string = 'win11-21h2-pro'
param linuxOffer string = 'UbuntuServer'
param linuxSKU string = '18.04-LTS'
param computername string = 'computerName'

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
      vmSize: vmSize
    }
    osProfile: {
      computerName: computername
      adminUsername: uname
      adminPassword: password
    }
    storageProfile: uselinux == false ? {
      imageReference: {
        publisher: 'MicrosoftWindowsDesktop'
        offer: windowsOffer
        sku: windowsSku
        version: 'latest'
      }
      osDisk: {
        name: 'osdisk'
        caching: 'ReadWrite'
        createOption: 'FromImage'
      }
    } : {
      osDisk: {
        createOption: 'FromImage'
      }
      imageReference: {
        publisher: 'Canonical'
        offer: linuxOffer
        sku: linuxSKU
        version: 'latest'
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
