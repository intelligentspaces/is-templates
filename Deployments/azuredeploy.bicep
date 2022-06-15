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
param lifecycle string 
param location string
@minLength(1) 
@maxLength(11)
param projectName string 
@minLength(1) 
@maxLength(3)
param resourcePrefix string 
param storageAccountName string = '${toLower(projectName)}${lifecycle}stg${resourcePrefix}'
param storageContainerName string = '3dscenestore'
param digitalTwinName string = '${toLower(projectName)}${lifecycle}twin${resourcePrefix}'

/* 
******************  
    Variables
****************** 
*/
var tags = {
  dpor: 'Elastacloud Ltd'
  version: '3.0.0.0'
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




