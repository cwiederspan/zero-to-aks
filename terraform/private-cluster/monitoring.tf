resource "azurerm_application_insights" "insights" {
  name                = "${local.base_name}-appi"
  location            = "${azurerm_resource_group.group.location}"
  resource_group_name = "${azurerm_resource_group.group.name}"
  application_type    = "Web"

  #tags = "${var.tags}"
}

resource "azurerm_log_analytics_workspace" "workspace" {
  name                = "${local.base_name}-wksp"
  location            = "${azurerm_resource_group.group.location}"
  resource_group_name = "${azurerm_resource_group.group.name}"
  sku                 = "PerGB2018"
  retention_in_days   = 30

  #tags = "${var.tags}"
}

resource "azurerm_log_analytics_solution" "test" {
  solution_name         = "ContainerInsights"
  location              = "${azurerm_log_analytics_workspace.workspace.location}"
  resource_group_name   = "${azurerm_resource_group.group.name}"
  workspace_resource_id = "${azurerm_log_analytics_workspace.workspace.id}"
  workspace_name        = "${azurerm_log_analytics_workspace.workspace.name}"

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }
}
