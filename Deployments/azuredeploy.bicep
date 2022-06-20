/* 
******************  
    Parameters
****************** 
*/
@allowed([
  'dev'
  'test'
  'prod'
])
@description('Lifecycle to identify the environment to create.')
param lifecycle string = 'dev'
@minLength(1) 
@maxLength(11)
@description('Name of the project.')
param projectName string = 'eis'
@minLength(1) 
@maxLength(3)
@description('Resource Prefix to identify each resource.')
param resourcePrefix string = '01'
@description('Location for all resources.')
param location string = resourceGroup().location


/* 
******************  
    Variables
****************** 
*/
var storageAccountName = '${toLower(projectName)}${lifecycle}stg${resourcePrefix}'
var storageContainerName = '3dscenestore'
var digitalTwinName = '${toLower(projectName)}${lifecycle}twin${resourcePrefix}'

var tags = {
  dpor: 'Elastacloud Ltd'
  version: '1.0.0.0'
  environment: lifecycle
  project:  'EIS'
}

/* 
******************  
    Resources
****************** 
*/

// Storage Account
resource stg_resource 'microsoft.storage/storageAccounts@2019-06-01' = {
  name: storageAccountName
  tags: tags
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'Storage'
}

// Storage Container
resource blob_resource 'microsoft.storage/storageAccounts/blobServices/containers@2019-06-01' = {
  name: '${stg_resource.name}/default/${storageContainerName}'
  properties: {
    publicAccess: 'None'
  }
}

// Digital Twin
resource digitalTwin_resource 'Microsoft.DigitalTwins/digitalTwinsInstances@2020-03-01-preview' = {
  name: digitalTwinName
  location: location
  tags: tags
  sku: {
    name: 'F1'
  }
}

/* 
******************  
  Outputs
******************
*/
output digitalTwinN string = digitalTwin_resource.name
output digitalTwinHostname string = digitalTwin_resource.properties.hostName




