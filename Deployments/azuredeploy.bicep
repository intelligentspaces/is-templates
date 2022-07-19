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
@description('Development lifecycle of the deployment, this is included as part of the name to help identify resources and keep them unique')
param lifecycle string = 'dev'

@description('Region where the resources will be deployed to')
param location string = resourceGroup().location

@minLength(1) 
@maxLength(11)
@description('The name the project for which the deployment is being carried out for')
param projectName string 

@minLength(1) 
@maxLength(3)
@description('Suffix to add to the resources to help identify them')
param resourceSuffix string 

/* 
******************  
    Variables
****************** 
*/
var storageAccountName = '${toLower(projectName)}${lifecycle}stg${resourceSuffix}'
var storageContainerName = '3dscenestore'
var digitalTwinName = '${toLower(projectName)}${lifecycle}twin${resourceSuffix}'

var tags = {
  dpor: 'Elastacloud Ltd'
  version: '1.0.0.0'
  environment: lifecycle
  solutionProvider:  'intelligentspaces.io'
  project: projectName
}

/* 
******************  
    Resources
****************** 
*/

// Storage Account
resource stg 'Microsoft.Storage/storageAccounts@2021-09-01' = {
  name: storageAccountName
  tags: tags
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    minimumTlsVersion: 'TLS1_2'
    supportsHttpsTrafficOnly: true
    encryption: {
      keySource: 'Microsoft.Storage'
      services: {
        blob: {
          enabled: true
        }
        file: {
          enabled: true
        }
        queue: {
          enabled: true
        }
        table: {
          enabled: true
        }
      }
    }
  }
}
  
resource container 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-09-01' = {
  parent: services
  name: storageContainerName
  properties: {
    publicAccess: 'None'
  }
}

resource services 'Microsoft.Storage/storageAccounts/blobServices@2021-09-01' = {
  parent: stg
  name: 'default'
  properties: {
    cors: {
      corsRules: [
        {
          allowedOrigins: [
            'https://explorer.digitaltwins.azure.net'
          ]
          allowedMethods: [
            'GET'
            'OPTIONS'
            'POST'
            'PUT'
          ]
          maxAgeInSeconds: 0
          allowedHeaders: [
            'Authorization,x-ms-version,x-ms-blob-type'
          ]
          exposedHeaders: [
            ''
          ]
        }
      ]
    }
  }
}

// Digital Twin
resource adt 'Microsoft.DigitalTwins/digitalTwinsInstances@2021-06-30-preview' = {
  name: digitalTwinName
  location: location
  tags: tags
  properties: {
    publicNetworkAccess: 'Enabled'
  }
}

/* 
******************  
  Outputs
******************
*/

output digitalTwinHostname string = adt.properties.hostName
output storageAccountKey string = 'DefaultEndpointsProtocol=https;AccountName=${stg.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${stg.listKeys().keys[0].value}'
output storageAccountCotainerURI string = '${stg.properties.primaryEndpoints.blob}${storageContainerName}'




