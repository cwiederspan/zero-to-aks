# since these variables are re-used - a locals block makes this more maintainable
locals {

  backend_address_pool_name      = "${var.gateway_name}-bepool"
  frontend_port_name             = "${var.gateway_name}-feport"
  frontend_ip_configuration_name = "${var.gateway_name}-feip"
  http_setting_name              = "${var.gateway_name}-http"
  listener_name                  = "${var.gateway_name}-lstn"
  probe_name                     = "${var.gateway_name}-probe"
  request_routing_rule_name      = "${var.gateway_name}-router"
  gateway_ip_config_name         = "${var.gateway_name}-ipconfig"
  url_path_map_name              = "${var.gateway_name}-urlpath"
  url_path_map_rule_name         = "${var.gateway_name}-urlrule"
  ssl_name                       = "${var.gateway_name}-ssl"
}


resource "azurerm_storage_account" "storage" {
  name                     = "${var.storage_name}"
  resource_group_name      = "${azurerm_resource_group.group.name}"
  location                 = "${azurerm_resource_group.group.location}"
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  
  # Update: This is now taking place in the Azure DevOps pipeline
  # This should use native functionality to turn on static sites for the azurerm, but it's not available yet.
  # Read More: https://github.com/terraform-providers/terraform-provider-azurerm/issues/1903
  # provisioner "local-exec" {
  #   command = "az storage blob service-properties update --account-name ${azurerm_storage_account.storage.name} --static-website --index-document index.html"
  # }
}

resource "azurerm_application_gateway" "gateway" {
  name                = "${var.gateway_name}"
  resource_group_name = "${azurerm_resource_group.group.name}"
  location            = "${azurerm_resource_group.group.location}"

  sku {
    name     = "WAF_v2"
    tier     = "WAF_v2"
    capacity = "${var.gateway_instance_count}"
  }

  gateway_ip_configuration {
    name      = "${local.gateway_ip_config_name}"
    subnet_id = "${azurerm_subnet.subnet.id}"
  }

  frontend_port {
    name = "${local.frontend_port_name}-http"
    port = 80
  }

  frontend_port {
    name = "${local.frontend_port_name}-https"
    port = 443
  }

  frontend_ip_configuration {
    name                 = "${local.frontend_ip_configuration_name}"
    public_ip_address_id = "${azurerm_public_ip.ip.id}"
  }

  backend_address_pool {
    name  = "${local.backend_address_pool_name}-www"
    fqdns = ["${azurerm_app_service.frontend.default_site_hostname}"]
  }

  backend_address_pool {
    name  = "${local.backend_address_pool_name}-api"
    fqdns = ["${azurerm_app_service.backend.default_site_hostname}"]
  }

  # TODO: This should use an export value from the storage account once that functionality is available
  backend_address_pool {
    name  = "${local.backend_address_pool_name}-util"
    fqdns = ["${var.storage_name}.z5.web.core.windows.net"]   # Hard-coded for now, until azurerm can handle setting up static site in storage
  }

  backend_http_settings {
    name                  = "${local.http_setting_name}"
    cookie_based_affinity = "Disabled"
    port                  = 443
    protocol              = "https"
    request_timeout       = 1
    probe_name            = "${local.probe_name}"
    pick_host_name_from_backend_address = "true"
  }

  http_listener {
    name                           = "${local.listener_name}-http"
    frontend_ip_configuration_name = "${local.frontend_ip_configuration_name}"
    frontend_port_name             = "${local.frontend_port_name}-http"
    protocol                       = "http"
  }

  http_listener {
    name                           = "${local.listener_name}-https"
    frontend_ip_configuration_name = "${local.frontend_ip_configuration_name}"
    frontend_port_name             = "${local.frontend_port_name}-https"
    protocol                       = "https"
    ssl_certificate_name           = "${local.ssl_name}"
  }

  ssl_certificate {
    name       = "${local.ssl_name}"
    data       = "${file("${var.ssl_filename}")}"
    password   = "${var.ssl_password}"
  }

  probe {
    name                = "${local.probe_name}"
    protocol            = "https"
    path                = "/"
    interval            = 30
    timeout             = 30
    unhealthy_threshold = 3
    pick_host_name_from_backend_http_settings = "true"
  }

  request_routing_rule {
    name                           = "${local.request_routing_rule_name}-http"
    rule_type                      = "PathBasedRouting"
    http_listener_name             = "${local.listener_name}-http"
    url_path_map_name              = "${local.url_path_map_name}"
  }

  request_routing_rule {
    name                           = "${local.request_routing_rule_name}-https"
    rule_type                      = "PathBasedRouting"
    http_listener_name             = "${local.listener_name}-https"
    url_path_map_name              = "${local.url_path_map_name}"
  }

  url_path_map {
    name                               = "${local.url_path_map_name}"
    default_backend_address_pool_name  = "${local.backend_address_pool_name}-www"
    default_backend_http_settings_name = "${local.http_setting_name}"
    
    path_rule {
      name                       = "${local.url_path_map_rule_name}-api"
      backend_address_pool_name  = "${local.backend_address_pool_name}-api"
      backend_http_settings_name = "${local.http_setting_name}"
      paths = [
        "/api/*"
      ]
    }
    
    path_rule {
      name                       = "${local.url_path_map_rule_name}-util"
      backend_address_pool_name  = "${local.backend_address_pool_name}-util"
      backend_http_settings_name = "${local.http_setting_name}"
      paths = [
        "/.well-known/acme-challenge/*"
      ]
    }
  }
}