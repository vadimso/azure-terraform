provider "azurerm" {
  version = "3.55.0"
  features {
  
  }
}

resource "random_pet" "rg_name" {
  prefix = var.resource_group_name_prefix
}

resource "azurerm_resource_group" "rg1" {
  location = var.resource_group_location
  name     = random_pet.rg_name.id
}

# resource "azurerm_resource_group" "rg1" {
#   name     = "rg1"
#   location = "West US"
# }

resource "azurerm_virtual_network" "vnet1" {
  name                = "my-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
}

resource "azurerm_storage_account" "sg" {
  name                     = "mystorageaccount"
  resource_group_name      = azurerm_resource_group.rg1.name
  location                 = azurerm_resource_group.rg1.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_function_app" "app_func" {
  name                      = "my-function-app"
  location                  = azurerm_resource_group.rg1.location
  resource_group_name       = azurerm_resource_group.rg1.name
  app_service_plan_id       = azurerm_app_service_plan.app-serv.id
  storage_account_name      = azurerm_storage_account.sg.name
  storage_account_access_key = azurerm_storage_account.sg.primary_access_key
}

resource "azurerm_app_service_plan" "app-serv" {
  name                = "my-app-service-plan"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
  kind                = "FunctionApp"

  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

# resource "azurerm_resource_group" "example" {
#   name     = "my-resource-group"
#   location = "eastus"
# }

resource "azurerm_virtual_network" "vnet2" {
  name                = "my-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
}

resource "azurerm_subnet" "my-subnet" {
  name                 = "my-subnet"
  resource_group_name  = azurerm_resource_group.rg1.name
  virtual_network_name = azurerm_virtual_network.vnet2.name
  address_prefixes     = ["10.0.1.0/24"]
}

# resource "azurerm_function_app" "my-function-app" {
#   name                      = "my-function-app"
#   location                  = azurerm_resource_group.rg1
#   resource_group_name       = azurerm_resource_group.rg1
#   app_service_plan_id       = azurerm_app_service_plan.my-app-service-plan.id
#   storage_account_access_key = azurerm_storage_account.sg.primary_access_key
# }

resource "azurerm_app_service_plan" "my-app-service-plan" {
  name                = "my-app-service-plan"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
  kind                = "FunctionApp"

  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

resource "azurerm_private_endpoint" "my-private-endpoint" {
  name                = "my-private-endpoint"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
  subnet_id           = azurerm_subnet.example.id

  private_service_connection {
    name                           = "my-function-app-connection"
    private_connection_resource_id = azurerm_function_app.example.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }
}

resource "azurerm_private_dns_zone" "privatelink_azurewebsites_net" {
  name                = "privatelink.azurewebsites.net"
  resource_group_name = azurerm_resource_group.rg1.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "my-vnet-dns-link" {
  name                  = "my-vnet-dns-link"
  resource_group_name   = azurerm_resource_group.rg1.name
  private_dns_zone_name = azurerm_private_dns_zone.privatelink_azurewebsites_net.name
  virtual_network_id    = azurerm_virtual_network.example.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "my_function_app" {
  name                  = "my-function-app-dns-link"
  resource_group_name   = azurerm_resource_group.rg1.name
  private_dns_zone_name = azurerm_private_dns_zone.privatelink_azurewebsites_net.name
  virtual_network_id    = azurerm_virtual_network.example.id
}

# output "private_endpoint_fqdn" {
#   value = azurerm_private_endpoint.example.private_service_connection[0].private_endpoint_dns_zone_name
# }

#esource "azurerm_resource_group" "example" {
#   name     = "my-resource-group"
#   location = "eastus"
# }

resource "azurerm_virtual_network" "example" {
  name                = "my-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
}

resource "azurerm_subnet" "example" {
  name                 = "my-subnet"
  resource_group_name  = azurerm_resource_group.rg1.name
  virtual_network_name = azurerm_virtual_network.vnet2.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_storage_account" "example" {
  name                     = "mystorageaccount"
  resource_group_name      = azurerm_resource_group.rg1.name
  location                 = azurerm_resource_group.rg1.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_private_endpoint" "private_endpoint" {
  name                = "my-private-endpoint"
  location            = azurerm_resource_group.rg1.name
  resource_group_name = azurerm_resource_group.rg1.name
  subnet_id           = azurerm_subnet.example.id

  private_service_connection {
    name                           = "my-storage-account-connection"
    private_connection_resource_id = azurerm_storage_account.example.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }
}

# Create an Azure Function App
resource "azurerm_function_app" "example" {
  name                      = "my-function-app"
  resource_group_name       = azurerm_resource_group.rg1.name
  location                  = azurerm_resource_group.rg1.location
  app_service_plan_id       = azurerm_app_service_plan.app-serv.id
  storage_account_name      = azurerm_storage_account.sg.name
  storage_account_access_key = azurerm_storage_account.sg.primary_access_key

  # Other function app configuration properties...
}

# Create an Azure Storage Account
resource "azurerm_storage_account" "sg1" {
  name                     = "mysg"
  resource_group_name      = azurerm_resource_group.rg1.name
  location                 = azurerm_resource_group.rg1.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
   identity {
    type = "SystemAssigned"
  }
  # Other storage account configuration properties...
}

# Enable Managed Identity for the Function App
resource "azurerm_function_app" "azurerm_function_app" {
  # ...
resource_group_name       = azurerm_resource_group.rg1.name
name                      = "my-function-app"
location                  = azurerm_resource_group.rg1.location
app_service_plan_id       = azurerm_app_service_plan.app-serv.id
storage_account_name      = azurerm_storage_account.sg.name
storage_account_access_key = azurerm_storage_account.sg.primary_access_key
  identity {
    type = "SystemAssigned"
  }



  # ...
}

# Enable Managed Identity for the Storage Account
# resource "azurerm_storage_account" "sg1" {
#   # ...

#   identity {
#     type = "SystemAssigned"
#   }

#   # ...
# }

resource "azurerm_role_assignment" "azure_role" {
  scope                = azurerm_storage_account.sg1.name
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_function_app.app_func.id
}

#using Azure.Storage.Blobs;

#var blobServiceClient = new BlobServiceClient("<storage-account-connection-string>");
