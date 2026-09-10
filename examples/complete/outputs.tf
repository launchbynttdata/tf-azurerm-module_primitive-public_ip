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

output "public_ip_id" {
  value       = module.public_ip.id
  description = "The ID of this Public IP."
}

output "public_ip_name" {
  value       = module.public_ip.name
  description = "The Name of this Public IP."
}

output "ip_address" {
  value       = module.public_ip.ip_address
  description = "The IP address value that was allocated."
}

output "fqdn" {
  value       = module.public_ip.fqdn
  description = "Fully qualified domain name of the A DNS record associated with the public IP. domain_name_label must be specified to get the fqdn. This is the concatenation of the domain_name_label and the regionalized DNS zone"
}

output "resource_group_name" {
  value       = local.resource_group_name
  description = "Name of the resource group to be created."
}

output "virtual_machine_id" {
  value       = module.virtual_machine.id
  description = "ID of the virtual machine to be created."
}

output "virtual_machine_name" {
  value       = local.virtual_machine_name
  description = "Name of the virtual machine to be created."
}

output "virtual_machine_public_ip_address" {
  value       = module.virtual_machine.public_ip_address
  description = "IP Address of the virtual machine to be created."
}
