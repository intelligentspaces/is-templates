# Deploy and Azure Digital Twin

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fintelligentspaces%2Fis-templates%2Finfrastructure-deploy%2FDeployments%2Fazuredeploy.json)

This template will deploy the components necessary to create an [Azure Digital Twin](https://azure.microsoft.com/services/digital-twins/) instance which can support 3D scenes. This includes

1. The Azure Digital Twin instance
1. A storage account with a pre-configured container
   1. With HTTPS only traffic enabled
   1. TLS version set to 1.2
   1. Encryption enabled for all services

For more information about Digital Twins and combining them with telemetry data in a platform owned by you, then visit us at [Intelligent Spaces](https://intelligentspaces.io)
