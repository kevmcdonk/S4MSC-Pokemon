param connections_Pokemon_name string = 'S4MSCPokemonTest'
param region string = 'uksouth'
param tenantId string = ''
param clientId string = ''
param secret string = ''

var workflows_SearchConnectorSetup_name_var = 'la-${connections_Pokemon_name}-setup'
var workflows_SearchConnectorSearch_name_var = 'la-${connections_Pokemon_name}-search'
var graphConnectorUrl = 'https://graph.microsoft.com/v1.0/external/connections/${connections_Pokemon_name}'

resource workflows_SearchConnectorSetup_name 'Microsoft.Logic/workflows@2017-07-01' = {
  name: workflows_SearchConnectorSetup_name_var
  location: region
  properties: {
    state: 'Enabled'
    definition: {
      '$schema': 'https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#'
      actions: {
        Check_PokemonSearchConnector_exists: {
          inputs: {
            authentication: {
              audience: 'https://graph.microsoft.com'
              clientId: clientId
              secret: secret
              tenant: tenantId
              type: 'ActiveDirectoryOAuth'
            }
            method: 'GET'
            uri: graphConnectorUrl
          }
          runAfter: {}
          type: 'Http'
        }
        Check_schema_exists: {
          inputs: {
            authentication: {
              audience: 'https://graph.microsoft.com'
              clientId: clientId
              secret: secret
              tenant: tenantId
              type: 'ActiveDirectoryOAuth'
            }
            method: 'GET'
            uri: '${graphConnectorUrl}/schema'
          }
          runAfter: {
            Update_schema_if_exists: [
              'Succeeded'
              'Skipped'
            ]
          }
          type: 'Http'
        }
        'Create_S4MSC-PokemonSearchConnector_if_not_exist': {
          inputs: {
            authentication: {
              audience: 'https://graph.microsoft.com'
              clientId: clientId
              secret: secret
              tenant: tenantId
              type: 'ActiveDirectoryOAuth'
            }
            body: {
              description: 'Connector for showing key tweets'
              id: connections_Pokemon_name
              name: 'Pokemon Connector'
              enabledContentExperiences: 'search'
              configuration: {
                authorizedApps: [
                  clientId
                ]
                authorizedAppIds: [
                  clientId
                ]
              }
              searchSettings: {
                searchResultTemplates: [
                  {
                    id: connections_Pokemon_name
                    layout: {
                      type: 'AdaptiveCard'
                      version: '1.3'
                      body: [
                        {
                          type: 'ColumnSet'
                          columns: [
                            {
                              type: 'Column'
                              width: 'auto'
                              items: [
                                {
                                  type: 'Image'
                                  url: 'https://upload.wikimedia.org/wikipedia/commons/5/57/Pokemon_logo.svg'
                                  size: 'Small'
                                  horizontalAlignment: 'Center'
                                  altText: 'Pokemon logo'
                                }
                              ]
                              height: 'stretch'
                            }
                            {
                              type: 'Column'
                              width: 8
                              items: [
                                {
                                  type: 'TextBlock'
                                  text: '[\${name}](\${propertylink})'
                                  color: 'Accent'
                                  size: 'Medium'
                                  weight: 'Bolder'
                                }
                                {
                                  type: 'TextBlock'
                                  text: '\${description}'
                                  wrap: true
                                  maxLines: 3
                                  spacing: 'Medium'
                                }
                              ]
                              horizontalAlignment: 'Center'
                              spacing: 'Medium'
                            }
                            {
                              type: 'Column'
                              width: 2
                              items: [
                                {
                                  type: 'Image'
                                  url: '\${image}'
                                  altText: 'Result logo'
                                  size: 'Medium'
                                  horizontalAlignment: 'Right'
                                }
                              ]
                              '$when': '\${image != \'\'}'
                            }
                          ]
                        }
                      ]
                      '$schema': 'http://adaptivecards.io/schemas/adaptive-card.json'
                    }
                    priority: 0
                  }
                ]
              }
            }
            method: 'POST'
            uri: 'https://graph.microsoft.com/v1.0/external/connections'
          }
          runAfter: {
            Check_PokemonSearchConnector_exists: [
              'Failed'
            ]
          }
          type: 'Http'
        }
        Create_schema_if_it_not_exists: {
          inputs: {
            authentication: {
              audience: 'https://graph.microsoft.com'
              clientId: clientId
              secret: secret
              tenant: tenantId
              type: 'ActiveDirectoryOAuth'
            }
            body: {
              baseType: 'microsoft.graph.externalItem'
              properties: [
                {
                  isQueryable: true
                  isRefinable: false
                  isRetrievable: true
                  isSearchable: false
                  name: 'name'
                  type: 'String'
                }
                {
                  isQueryable: true
                  isRefinable: false
                  isRetrievable: true
                  isSearchable: false
                  name: 'order'
                  type: 'double'
                }
                {
                  isQueryable: true
                  isRefinable: false
                  isRetrievable: true
                  isSearchable: false
                  name: 'height'
                  type: 'double'
                }
                {
                  isQueryable: true
                  isRefinable: false
                  isRetrievable: true
                  isSearchable: false
                  name: 'weight'
                  type: 'double'
                }
                {
                  isQueryable: true
                  isRefinable: false
                  isRetrievable: true
                  isSearchable: false
                  name: 'baseExperience'
                  type: 'double'
                }
                {
                  isQueryable: true
                  isRefinable: false
                  isRetrievable: true
                  isSearchable: false
                  name: 'image'
                  type: 'String'
                }
                {
                  isQueryable: true
                  isRefinable: false
                  isRetrievable: true
                  isSearchable: false
                  name: 'types'
                  type: 'StringCollection'
                }
              ]
            }
            method: 'POST'
            uri: '${graphConnectorUrl}/schema'
          }
          runAfter: {
            Check_schema_exists: [
              'Failed'
            ]
          }
          type: 'Http'
        }
        Update_schema_if_exists: {
          inputs: {
            authentication: {
              audience: 'https://graph.microsoft.com'
              clientId: clientId
              secret: secret
              tenant: tenantId
              type: 'ActiveDirectoryOAuth'
            }
            body: {
              description: 'Connector for showing key tweets'
              id: connections_Pokemon_name
              name: 'Pokemon Connector'
              enabledContentExperiences: 'search'
              configuration: {
                authorizedApps: [
                  clientId
                ]
                authorizedAppIds: [
                  clientId
                ]
              }
              searchSettings: {
                searchResultTemplates: [
                  {
                    id: connections_Pokemon_name
                    layout: {
                      type: 'AdaptiveCard'
                      version: '1.3'
                      body: [
                        {
                          type: 'ColumnSet'
                          columns: [
                            {
                              type: 'Column'
                              width: 'auto'
                              items: [
                                {
                                  type: 'Image'
                                  url: 'https://searchuxcdn.blob.core.windows.net/designerapp/images/DefaultMRTIcon.png'
                                  size: 'Small'
                                  horizontalAlignment: 'Center'
                                  description: 'Thumbnail image'
                                }
                              ]
                              height: 'stretch'
                            }
                            {
                              type: 'Column'
                              width: 8
                              horizontalAlignment: 'Center'
                              spacing: 'Medium'
                              items: [
                                {
                                  type: 'TextBlock'
                                  text: 'https://dev.service-now.com/'
                                  weight: 'Bolder'
                                  color: 'Accent'
                                  size: 'Medium'
                                  maxLines: 3
                                }
                                {
                                  type: 'TextBlock'
                                  text: '\${description}'
                                  wrap: true
                                  maxLines: 3
                                  spacing: 'Medium'
                                }
                              ]
                            }
                            {
                              type: 'Column'
                              width: 2
                              items: [
                                {
                                  type: 'Image'
                                  url: '\${image}'
                                  description: '\${description}'
                                  horizontalAlignment: 'Center'
                                }
                              ]
                              '$when': '\${image != \'\'}'
                            }
                          ]
                        }
                      ]
                      '$schema': 'http://adaptivecards.io/schemas/adaptive-card.json'
                    }
                    priority: 0
                  }
                ]
              }
            }
            method: 'PATCH'
            uri: graphConnectorUrl
          }
          runAfter: {
            'Create_S4MSC-PokemonSearchConnector_if_not_exist': [
              'Skipped'
            ]
          }
          type: 'Http'
        }
      }
      contentVersion: '1.0.0.0'
      outputs: {}
      parameters: {}
      triggers: {
        manual: {
          inputs: {
            schema: {}
          }
          kind: 'Http'
          type: 'Request'
        }
      }
    }
    parameters: {}
  }
}

resource workflows_SearchConnectorSearch_name 'Microsoft.Logic/workflows@2017-07-01' = {
  name: workflows_SearchConnectorSearch_name_var
  location: region
  properties: {
    state: 'Enabled'
    definition: {
      '$schema': 'https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#'
      contentVersion: '1.0.0.0'
      parameters: {
        '$connections': {
          defaultValue: {}
          type: 'Object'
        }
      }
      triggers: {
        manual: {
          type: 'Request'
          kind: 'Http'
          inputs: {
            schema: {}
          }
        }
      }
      actions: {
        For_each: {
          foreach: '@body(\'List_Records\')?[\'result\']'
          actions: {
            Create_index_if_not_exists: {
              type: 'Http'
              inputs: {
                authentication: {
                  audience: 'https://graph.microsoft.com'
                  clientId: clientId
                  secret: secret
                  tenant: tenantId
                  type: 'ActiveDirectoryOAuth'
                }
                body: {
                  acl: [
                    {
                      accessType: 'grant'
                      identitySource: 'azureActiveDirectory'
                      type: 'everyone'
                      value: '43c5e796-f484-4157-8c93-73ac8b1cf7bf'
                    }
                  ]
                  content: {
                    type: 'text'
                    value: '@{items(\'For_each\')?[\'sys_name\']}'
                  }
                  properties: {
                    cost: '@float(items(\'For_each\')?[\'cost\'])'
                    description: '@{items(\'For_each\')?[\'description\']}'
                    group: '@{items(\'For_each\')?[\'group\']}'
                    image: '@{items(\'For_each\')?[\'image\']}'
                    name: '@{items(\'For_each\')?[\'name\']}'
                    order: '@float(items(\'For_each\')?[\'order\'])'
                    price: '@float(items(\'For_each\')?[\'price\'])'
                    productid: '@{items(\'For_each\')?[\'sys_id\']}'
                    productlink: 'https://dev.service-now.com/now/nav/ui/classic/params/target/com.glideapp.servicecatalog_cat_item_view.do%3Fv%3D1%26sysparm_id%3D@{items(\'for_each\')?[\'sys_id\']}'
                    shortdescription: '@{items(\'For_each\')?[\'short_description\']}'
                  }
                  type: 'microsoft.graph.externalItem'
                }
                method: 'PUT'
                uri: 'https://graph.microsoft.com/v1.0/external/connections/S4MSCSNow/items/@{items(\'For_each\')?[\'sys_id\']}'
              }
            }
            runAfter: {}
            type: 'Http'
          }
          Get_item_from_index_by_Product_Id: {
            runAfter: {}
            type: 'Http'
            inputs: {
              authentication: {
                audience: 'https://graph.microsoft.com'
                clientId: clientId
                secret: secret
                tenant: tenantId
                type: 'ActiveDirectoryOAuth'
              }
              method: 'GET'
              uri: '${graphConnectorUrl}/items/@{items(\'For_each\')?[\'sys_id\']}'
            }
          }
        }
        runAfter: {
          List_Records: [
            'Succeeded'
          ]
        }
        type: 'Foreach'
        runtimeConfiguration: {
          concurrency: {
            repetitions: 1
          }
        }
      }
      List_Records: {
        runAfter: {}
        type: 'ApiConnection'
        inputs: {
          host: {
            connection: {
              name: '@parameters(\'$connections\')[\'service-now\'][\'connectionId\']'
            }
          }
          method: 'get'
          path: '/api/now/v2/table/@{encodeURIComponent(\'pc_product_cat_item\')}'
          queries: {
            sysparm_display_value: false
            sysparm_exclude_reference_link: true
            sysparm_query: 'fields=price,product_id,sys_name,model,state,group,order,image,active,name,vendor_catalog_item,short_description,icon,description,availability,owner,list_price,recurring_price'
          }
        }
      }
    }
    outputs: {}
    parameters: {
      '$connections': {
        value: {
          'service-now': {
            connectionId: resourceId('Microsoft.Web/connections', 'service-now')
            connectionName: 'service-now'
            id: '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Web/locations/${region}/managedApis/service-now'
          }
        }
      }
    }
  }
}