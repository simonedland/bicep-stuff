
resource loadBalancerInternal 'Microsoft.Network/loadBalancers@2020-11-01' = {
  name: 'name'
  location: location
  properties: {
    frontendIPConfigurations: [
      {
        name: 'name'
        properties: {
          privateIPAddress: '0.0.0.0'
          privateIPAllocationMethod: 'Static'
          subnet: {
            id: 'subnet.id'
          }
        }
      }
    ]
    backendAddressPools: [
      {
        name: 'name'
      }
    ]
    loadBalancingRules: [
      {
        name: 'name'
        properties: {
          frontendIPConfiguration: {
            id: 'frontendIPConfiguration.id'
          }
          backendAddressPool: {
            id: 'backendAddressPool.id'
          }
          protocol: 'Tcp'
          frontendPort: 80
          backendPort: 80
          enableFloatingIP: false
          idleTimeoutInMinutes: 5
          probe: {
            id: 'probe.id'
          }
        }
      }
    ]
    probes: [
      {
        name: 'name'
        properties: {
          protocol: 'Tcp'
          port: 80
          intervalInSeconds: 5
          numberOfProbes: 2
        }
      }
    ]
  }
}
