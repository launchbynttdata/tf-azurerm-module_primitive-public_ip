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

locals {
  resource_group_name    = module.resource_names["resource_group"].minimal_random_suffix
  virtual_machine_name   = "testvm"
  network_interface_name = module.resource_names["network_interface"].minimal_random_suffix

  override_network_attributes_map = { for vnet_name, vnet in var.network_map : vnet_name => {
    resource_group_name = local.resource_group_name
    vnet_name           = module.resource_names["${vnet_name}_vnet"].standard
    location            = var.region
    }
  }

  modified_network_map = {
    for vnet_name, vnet in var.network_map : vnet_name => merge(vnet, local.override_network_attributes_map[vnet_name])
  }

  default_tags = {
    provisioner = "Terraform"
  }

  tags = merge(local.default_tags, var.tags)
}
