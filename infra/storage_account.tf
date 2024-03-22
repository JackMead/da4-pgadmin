resource "azurerm_storage_account" "main" {
  name                     = var.storage_account_name
  resource_group_name      = data.azurerm_resource_group.main.name
  location                 = "UK South" # Change to your desired location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {}

  account_kind = "StorageV2"
}

resource "azurerm_storage_share" "main" {
  name                 = "pg-admin-files"
  storage_account_name = azurerm_storage_account.main.name
  quota                = 50
  access_tier          = "Hot"
}