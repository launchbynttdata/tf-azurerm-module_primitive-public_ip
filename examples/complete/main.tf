// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

# This module generates the resource-name of resources based on resource_type, naming_prefix, env etc.
module "resource_names" {
  source = "git::https://github.com/launchbynttdata/tf-launch-module_library-resource_name.git?ref=1.0.0"

  for_each = var.resource_names_map

  region                  = var.region
  class_env               = var.environment
  cloud_resource_type     = each.value.name
  instance_env            = var.instance_env
  instance_resource       = var.instance_resource
  maximum_length          = each.value.max_length
  logical_product_family  = var.logical_product_family
  logical_product_service = var.logical_product_service
}

module "resource_group" {
  source = "git::https://github.com/launchbynttdata/tf-azurerm-module_primitive-resource_group.git?ref=1.0.0"

  name     = local.resource_group_name
  location = var.region
  tags = merge(local.tags, {
    resource_name = local.resource_group_name
  })
}

module "public_ip" {
  source = "../.."

  name                = module.resource_names["public_ip"].minimal_random_suffix
  resource_group_name = local.resource_group_name
  location            = var.region
  allocation_method   = var.allocation_method

  tags = merge(local.tags, {
    resource_name = module.resource_names["public_ip"].minimal_random_suffix
  })

  depends_on = [module.resource_group]
}

resource "random_string" "admin_password" {
  length  = var.length
  numeric = var.number
  special = var.special
}

module "virtual_machine" {
  source = "git::https://github.com/launchbynttdata/tf-azurerm-module_primitive-windows_virtual_machine.git?ref=1.0.0"

  name                = local.virtual_machine_name
  resource_group_name = local.resource_group_name
  location            = var.region
  size                = var.size

  admin_username = var.admin_username
  admin_password = random_string.admin_password.result

  os_disk                = var.os_disk
  source_image_reference = var.source_image_reference
  network_interface_ids  = [module.network_interface.id]

  depends_on = [module.resource_group]
}

module "network_interface" {
  source = "git::https://github.com/launchbynttdata/tf-azurerm-module_primitive-network_interface.git?ref=1.0.0"

  name                = local.network_interface_name
  location            = var.region
  resource_group_name = local.resource_group_name

  ip_configuration = {
    name                          = "internal"
    subnet_id                     = module.virtual_network.vnet_subnets["virtual_network"][0]
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = module.public_ip.id
  }
  depends_on = [module.resource_group, module.virtual_network, module.public_ip]
}

module "virtual_network" {
  source = "git::https://github.com/launchbynttdata/tf-azurerm-module_collection-virtual_network.git?ref=1.0.0"

  network_map = local.modified_network_map

  depends_on = [module.resource_group]
}
