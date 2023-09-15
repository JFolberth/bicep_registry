@description('Name for the App Service')
param appServiceName string
@description('Location for resource.')
param location string
@description('Resource ID of the App Service Plan')
param appServicePlanID string
@description('User Asisgned Identity for App Service')
param principalId string = ''
@description('App Settings for the Application')
param appSettings object = {}


resource appService 'Microsoft.Web/sites@2022-09-01' = {
  name: toLower('app-${appServiceName}')
  location: location
  identity: empty(principalId) ? {
    type: 'SystemAssigned'

  }:{
    type: 'SystemAssigned, UserAssigned'
    userAssignedIdentities: {
      '${principalId}': {}
    
  }
  }
  tags: {
    displayName: 'Website'
  }
  properties: {
    serverFarmId: appServicePlanID
    httpsOnly: true
    siteConfig: {
      minTlsVersion: '1.2'
    }
  }
}

resource appServiceLogging 'Microsoft.Web/sites/config@2022-09-01' = {
  parent: appService
  name: 'appsettings'
  properties: union(list(resourceId('Microsoft.Web/sites/config', appService.name, 'appsettings'), '2022-09-01').properties, appSettings)
}


output appServiceManagedIdentity string = appService.identity.principalId
output appServiceName string = appService.name
