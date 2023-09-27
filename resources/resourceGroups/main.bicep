@description('Location for all resources.')
param location string
@description('Base name that will appear for all resources.') 
param baseName string = 'iacflavorsbicepASP'
@description('Key Value Pair for tags.')
param tags object = {}

targetScope = 'subscription'

resource resourceGroup 'Microsoft.Resources/resourceGroups@2023-07-01' ={
  name: toLower('rg-${baseName}')
  location: location
  tags: tags
}

output resourceGroupName string = resourceGroup.name
