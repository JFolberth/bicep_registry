@description('Name for the User Assigned Identity')
param userIdentityName string
@description('Location for resource.')
param location string

resource uid 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: toLower('ui-${userIdentityName}')
  location: location

}

output userIdentityPrincipalOutput string = uid.properties.principalId
output userIdentityNameOutput string = uid.name
output userIdentityResrouceId string = uid.id
