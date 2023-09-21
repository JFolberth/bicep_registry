param databaseAccountName string
param databaseAccountResourceGroup string
param roleDefinitionId string = '00000000-0000-0000-0000-000000000002' // Built-in role 'Azure Cosmos DB Built-in Data Contributor'
param principalId string
@description('Data actions permitted by the Role Definition')
param dataActions array = [
  'Microsoft.DocumentDB/databaseAccounts/readMetadata'
  'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/items/*'
]
@description('Friendly name for the SQL Role Definition')
param roleDefinitionName string = 'My Read Write Role'

var roleAssignmentId = guid(roleDefinitionId, principalId, databaseAccount.id)
var roleDefinition = guid('sql-role-definition-', principalId, databaseAccount.id)
resource databaseAccount 'Microsoft.DocumentDB/databaseAccounts@2023-04-15' existing = {
  name: databaseAccountName
}

/*
resource sqlRoleDefinition 'Microsoft.DocumentDB/databaseAccounts/sqlRoleDefinitions@2023-04-15' existing = {
  name: '${databaseAccount.name}/Cosmos DB Built-in Data Reader'
  properties: {
    roleName: roleDefinitionName
    type: 'CustomRole'
    assignableScopes: [
      databaseAccount.id
    ]
    permissions: [
      {
        dataActions: dataActions
      }
    ]
  }
}
*/

resource sqlRoleAssignment 'Microsoft.DocumentDB/databaseAccounts/sqlRoleAssignments@2023-04-15' = {
  name: roleAssignmentId
  parent: databaseAccount
  properties:{
    principalId: principalId
    roleDefinitionId: '/${subscription().id}/resourceGroups/${databaseAccountResourceGroup}/providers/Microsoft.DocumentDB/databaseAccounts/${databaseAccount.name}/sqlRoleDefinitions/${roleDefinitionId}'
    scope: databaseAccount.id
  }
}
