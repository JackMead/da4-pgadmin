
resource "azurerm_service_plan" "main" {
  name                = "${var.app_service_name}-plan"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  sku_name            = "B1"
  os_type             = "Linux"
}

resource "azurerm_linux_web_app" "main" {
  name                = var.app_service_name
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  service_plan_id     = azurerm_service_plan.main.id

  site_config {
    application_stack {
      docker_image_name = "dpage/pgadmin4:latest"
      docker_registry_url = "https://index.docker.io"
    }
  }

  # Enable the Container Continuous Deployment Preview feature
  app_settings = {
    DOCKER_ENABLE_CI         = "true"
    PGADMIN_DEFAULT_EMAIL    = var.default_admin_email
    PGADMIN_DEFAULT_PASSWORD = var.default_admin_password
    # Per PGAdmin's advice (https://www.pgadmin.org/docs/pgadmin4/development/config_py.html)
    # Disable cookie protection to work within Azure DNS
    PGADMIN_CONFIG_ENHANCED_COOKIE_PROTECTION = "False"
  }

  storage_account {
    account_name = azurerm_storage_account.main.name
    access_key   = azurerm_storage_account.main.primary_access_key
    name         = "pgadmin_files"
    type         = "AzureFiles"
    share_name   = azurerm_storage_share.main.name
    mount_path   = "/var/lib/pgadmin"
  }
}