@description('CosmosDB Account to apply the role assignment to')
param databaseAccountName string
@description('Resource group of the CosmosDB Account')
param databaseAccountResourceGroup string
@description('Role definition id to assign to the principal')
@allowed([
  '00000000-0000-0000-0000-000000000001' // Built-in role 'Azure Cosmos DB Built-in Data Reader'
  '00000000-0000-0000-0000-000000000002' // Built-in role 'Azure Cosmos DB Built-in Data Contributor'
])
param roleDefinitionId string = '00000000-0000-0000-0000-000000000002'
@description('Principal id to assign the role to')
param principalId string

var roleAssignmentId = guid(roleDefinitionId, principalId, databaseAccount.id)
resource databaseAccount 'Microsoft.DocumentDB/databaseAccounts@2023-04-15' existing = {
  name: databaseAccountName
}

resource sqlRoleAssignment 'Microsoft.DocumentDB/databaseAccounts/sqlRoleAssignments@2023-04-15' = {
  name: roleAssignmentId
  parent: databaseAccount
  properties: {
    principalId: principalId
    roleDefinitionId: '/${subscription().id}/resourceGroups/${databaseAccountResourceGroup}/providers/Microsoft.DocumentDB/databaseAccounts/${databaseAccount.name}/sqlRoleDefinitions/${roleDefinitionId}'
    scope: databaseAccount.id
  }
}
