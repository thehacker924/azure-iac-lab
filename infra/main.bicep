param location string = resourceGroup().location
param prefix string = 'iaclab'

var storageName = '${prefix}${uniqueString(resourceGroup().id)}'

resource nsg 'Microsoft.Network/networkSecurityGroups@2023-11-01' = {
  name: '${prefix}-nsg'
  location: location
  properties: {
    securityRules: []
  }
}

resource vnet 'Microsoft.Network/virtualNetworks@2023-11-01' = {
  name: '${prefix}-vnet'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: ['10.10.0.0/16']
    }
    subnets: [
      {
        name: 'web'
        properties: {
          addressPrefix: '10.10.1.0/24'
          networkSecurityGroup: { id: nsg.id }
        }
      }
    ]
  }
}

resource storage 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: storageName
  location: location
  sku: { name: 'Standard_LRS' }
  kind: 'StorageV2'
  properties: {
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
    supportsHttpsTrafficOnly: true
  }
}

output storageAccountName string = storage.name
