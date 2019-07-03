variable "base_name" { }

variable "resource_group" { }

variable "location" { }

resource "azurerm_application_insights" "insights" {
  name                = "${var.base_name}-appi"
  resource_group_name = "${var.resource_group}"
  location            = "${var.location}"
  application_type    = "Web"

  #tags = "${var.tags}"
}

resource "azurerm_log_analytics_workspace" "workspace" {
  name                = "${var.base_name}-wksp"
  resource_group_name = "${var.resource_group}"
  location            = "${var.location}"
  sku                 = "PerGB2018"
  retention_in_days   = 30

  #tags = "${var.tags}"
}

resource "azurerm_log_analytics_solution" "test" {
  solution_name         = "ContainerInsights"
  location              = "${azurerm_log_analytics_workspace.workspace.location}"
  resource_group_name   = "${var.resource_group}"
  workspace_resource_id = "${azurerm_log_analytics_workspace.workspace.id}"
  workspace_name        = "${azurerm_log_analytics_workspace.workspace.name}"

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }
}

output "workspace_id" {
  value = "${azurerm_log_analytics_workspace.workspace.id}"
}
