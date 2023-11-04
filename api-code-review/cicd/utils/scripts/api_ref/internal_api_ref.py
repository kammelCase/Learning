import strenum

class InputJsonFields( strenum.StrEnum ):
    REQUEST = 'request'     # request       : object :: <this is the self-disclosure data from service-now/ITSM which would include anything from the ticket info to the form/workflow used to trigger the pipeline call> 
    ENVIRON = 'environ'     # environ       : string :: <this is the hosting environment>
    DEPLOYS = 'deploys'     # deploys       : object :: <this is the json inventory of the data we want to read as a terraform local-block>

## cloud provider map classes map json-fields in th API-request to the folder-names of the provider's tf-modules
class AzureResourceMap( strenum.StrEnum ):
    ## API request field string     : filesystem folder name string
    SUBNET                          = 'subnet'
    RESOURCEGROUP                   = 'resourcegroup'
    VIRTUALNETWORK                  = 'virtualnetwork'
    VNETPEERING                     = 'vnetpeering'
    DDOSPROTECTION                  = 'ddosprotection'
    SHAREDIMAGEGALLERY              = 'sharedimagegallery'
    WINDOWSVM                       = 'windowsvm'
    LINUXVM                         = 'linuxvm'
    MANAGEDDISK                     = 'manageddisk'
    SNAPSHOT                        = 'snapshot'
    KEYVAULT                        = 'keyvault'
    KEYVAULTKEYSECRET               = 'keyvaultkeysecret'
    WINDOWSVMEXTENSIONS             = 'windowsvmextensions'
    LINUXVMEXTENSIONS               = 'linuxvmextensions'
    WINDOWSVMSS                     = 'windowsvmss'
    LINUXVMSS                       = 'linuxvmss'
    VMSSEXTENSION                   = 'vmssextension'
    LOADBALANCER                    = 'loadbalancer'
    PUBLICIP                        = 'publicip'
    PRIVATEENDPOINTS                = 'privateendpoints'
    PRIVATELINKSERVICE              = 'privatelinkservice'
    STORAGEACCOUNT                  = 'storageaccount'
    STORAGECONTAINERS               = 'storagecontainers'
    DATALAKEGEN2FILESYSTEM          = 'datalakegen2filesystem'
    APPSERVICE                      = 'appservice'
    APPSERVICESLOT                  = 'appserviceslot'
    REDIS                           = 'redis'
    FUNCTION                        = 'function'
    AZURESQLDATABASE                = 'azuresqldatabase'
    MSSQLMANAGEDINSTANCE            = 'mssqlmanagedinstance'
    POSTGRESQLFLEXIBLESERVER        = 'postgresqlflexibleserver'
    MARIADBFLEXIBLESERVER           = 'mariadbflexibleserver'
    ACR                             = 'acr'
    AKS                             = 'aks'
    APPLICATIONGATEWAY              = 'applicationgateway'
    LOGANALYTICSWORKSPACE           = 'loganalyticsworkspace'
    EVENTGRID                       = 'eventgrid'
    EVENTHUB                        = 'eventhub'
    APPLICATIONINSIGHTS             = 'applicationinsights'
    METRICALERTS                    = 'metricalerts'
    MONITORDIAGSETTINGS             = 'monitordiagsettings'
    NETWORKWATCHER                  = 'networkwatcher'
    SERVICEPRINCIPAL                = 'serviceprincipal'
    MANAGEDIDENTITY                 = 'managedidentity'
    RBAC                            = 'rbac'
    UDR                             = 'udr'
    ASG                             = 'asg'
    ROUTETABLE                      = 'routetable'
    NSG                             = 'nsg'
    NSGRULES                        = 'nsgrules'
    WEBAPPLICATIONFIREWALL          = 'webapplicationfirewall'
    COGNITIVESERVICES               = 'cognitiveservices'
    COSMOSDB                        = 'cosmosdb'
    DNSZONE                         = 'dnszone'
    MLWORKSPACE                     = 'mlworkspace'
    SERVICEBUS                      = 'servicebus'
    FUNCTION_APP                    = 'function_app'
    AUTOSCALESETTINGS               = 'autoscalesettings'
    DATAFACTORY                     = 'datafactory'
    EVENTGRIDDOMAIN                 = 'eventgriddomain'
    EVENTGRIDTOPIC                  = 'eventgridtopic'
    LOGICAPP                        = 'logicapp'
    MONGODB                         = 'mongodb'
    VPN_SITE                        = 'vpn_site'
    POINT_TO_SITE_VPN_GATEWAY       = 'point_to_site_vpn_gateway'
    VIRTUAL_WAN                     = 'virtual_wan'
    VIRTUAL_HUB                     = 'virtual_hub'
    VPN_SERVER_CONFIGURATION        = 'vpn_server_configuration'

class AWSResourceMap( strenum.StrEnum ):
    MODULE_STUB = 'foldername'

class GCPResourceMap( strenum.StrEnum ):
    MODULE_STUB = 'foldername'

azure_api_options   = { field.name : field.value for field in AzureResourceMap  }
google_api_options  = { field.name : field.value for field in GCPResourceMap    }
amazon_api_options  = { field.name : field.value for field in AWSResourceMap    }

provider_api_options =  { 'azure'   : azure_api_options
                        , 'aws'     : amazon_api_options
                        , 'gcp'     : google_api_options
                        }

