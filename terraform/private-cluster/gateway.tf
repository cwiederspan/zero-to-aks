locals {
  gateway_name                   = "${local.base_name}-gateway"
  gateway_ip_name                = "${local.base_name}-ip"
  gateway_ip_config_name         = "${local.base_name}-ipconfig"
  frontend_port_name             = "${local.base_name}-feport"
  frontend_ip_configuration_name = "${local.base_name}-feip"
  backend_address_pool_name      = "${local.base_name}-bepool"
  http_setting_name              = "${local.base_name}-http"
  probe_name                     = "${local.base_name}-probe"
  listener_name                  = "${local.base_name}-lstn"
  ssl_name                       = "${local.base_name}-ssl"
  url_path_map_name              = "${local.base_name}-urlpath"
  url_path_map_rule_name         = "${local.base_name}-urlrule"
  request_routing_rule_name      = "${local.base_name}-router"
}

resource "azurerm_public_ip" "ip" {
  name                = local.gateway_ip_name
  resource_group_name = azurerm_resource_group.group.name
  location            = azurerm_resource_group.group.location
  domain_name_label   = local.gateway_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_application_gateway" "gateway" {
  name                = local.gateway_name
  resource_group_name = azurerm_resource_group.group.name
  location            = azurerm_resource_group.group.location

  sku {
    name     = "WAF_v2"
    tier     = "WAF_v2"
    capacity = var.gateway_instance_count
  }

  gateway_ip_configuration {
    name      = local.gateway_ip_config_name
    subnet_id = azurerm_subnet.gateway.id
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
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.ip.id
  }

  backend_address_pool {
    name         = local.backend_address_pool_name
    ip_addresses = [var.ingress_load_balancer_ip]
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "http"
    request_timeout       = 1
    probe_name            = local.probe_name
    #host                  = "${var.ingress_load_balancer_ip}"
    #pick_host_name_from_backend_address = "true"
  }

  http_listener {
    name                           = "${local.listener_name}-http"
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = "${local.frontend_port_name}-http"
    protocol                       = "http"
  }

  http_listener {
    name                           = "${local.listener_name}-https"
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = "${local.frontend_port_name}-https"
    protocol                       = "https"
    ssl_certificate_name           = local.ssl_name
  }

  ssl_certificate {
    name     = local.ssl_name
    data     = file(var.ssl_filename)
    password = var.ssl_password
  }

  probe {
    name                = local.probe_name
    protocol            = "http"
    path                = "/healthz" # Query NGINX ingress - this seems to work and is the path that shows up when dumping out the nginx config file
    interval            = 30
    timeout             = 30
    unhealthy_threshold = 3
    host                = var.ingress_load_balancer_ip
    # pick_host_name_from_backend_http_settings = "true"
  }

  request_routing_rule {
    name               = "${local.request_routing_rule_name}-http"
    rule_type          = "PathBasedRouting"
    http_listener_name = "${local.listener_name}-http"
    url_path_map_name  = local.url_path_map_name
  }

  request_routing_rule {
    name               = "${local.request_routing_rule_name}-https"
    rule_type          = "PathBasedRouting"
    http_listener_name = "${local.listener_name}-https"
    url_path_map_name  = local.url_path_map_name
  }

  url_path_map {
    name                               = local.url_path_map_name
    default_backend_address_pool_name  = local.backend_address_pool_name
    default_backend_http_settings_name = local.http_setting_name

    path_rule {
      name                       = local.url_path_map_rule_name
      backend_address_pool_name  = local.backend_address_pool_name
      backend_http_settings_name = local.http_setting_name
      paths = [
        "/*",
      ]
    }
  }
}

