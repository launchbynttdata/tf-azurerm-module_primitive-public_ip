# complete

This example includes a public IP attached to a virtual machine. Attaching the public IP to a virtual machine (or a load balancer) is the only way to be allocated a valid public IP addreess.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0, <= 1.5.5 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.77 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.6 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_random"></a> [random](#provider\_random) | 3.6.2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_resource_names"></a> [resource\_names](#module\_resource\_names) | terraform.registry.launch.nttdata.com/module_library/resource_name/launch | ~> 1.0 |
| <a name="module_resource_group"></a> [resource\_group](#module\_resource\_group) | terraform.registry.launch.nttdata.com/module_primitive/resource_group/azurerm | ~> 1.0 |
| <a name="module_public_ip"></a> [public\_ip](#module\_public\_ip) | ../.. | n/a |
| <a name="module_virtual_machine"></a> [virtual\_machine](#module\_virtual\_machine) | terraform.registry.launch.nttdata.com/module_primitive/windows_virtual_machine/azurerm | ~> 1.0 |
| <a name="module_network_interface"></a> [network\_interface](#module\_network\_interface) | terraform.registry.launch.nttdata.com/module_primitive/network_interface/azurerm | ~> 1.0 |
| <a name="module_virtual_network"></a> [virtual\_network](#module\_virtual\_network) | terraform.registry.launch.nttdata.com/module_collection/virtual_network/azurerm | ~> 1.0 |

## Resources

| Name | Type |
|------|------|
| [random_string.admin_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_resource_names_map"></a> [resource\_names\_map](#input\_resource\_names\_map) | A map of key to resource\_name that will be used by tf-launch-module\_library-resource\_name to generate resource names | <pre>map(object({<br>    name       = string<br>    max_length = optional(number, 80)<br>  }))</pre> | <pre>{<br>  "network_interface": {<br>    "max_length": 80,<br>    "name": "iface"<br>  },<br>  "public_ip": {<br>    "max_length": 80,<br>    "name": "ip"<br>  },<br>  "resource_group": {<br>    "max_length": 80,<br>    "name": "rg"<br>  },<br>  "virtual_machine": {<br>    "max_length": 15,<br>    "name": "vm"<br>  },<br>  "virtual_network_vnet": {<br>    "max_length": 80,<br>    "name": "vnet"<br>  }<br>}</pre> | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Project environment | `string` | `"demo"` | no |
| <a name="input_instance_env"></a> [instance\_env](#input\_instance\_env) | Number that represents the instance of the environment. | `number` | `0` | no |
| <a name="input_instance_resource"></a> [instance\_resource](#input\_instance\_resource) | Number that represents the instance of the resource. | `number` | `0` | no |
| <a name="input_region"></a> [region](#input\_region) | Region in which the infra needs to be provisioned | `string` | `"eastus2"` | no |
| <a name="input_logical_product_family"></a> [logical\_product\_family](#input\_logical\_product\_family) | (Required) Name of the product family for which the resource is created.<br>    Example: org\_name, department\_name. | `string` | `"launch"` | no |
| <a name="input_logical_product_service"></a> [logical\_product\_service](#input\_logical\_product\_service) | (Required) Name of the product service for which the resource is created.<br>    For example, backend, frontend, middleware etc. | `string` | `"publicip"` | no |
| <a name="input_allocation_method"></a> [allocation\_method](#input\_allocation\_method) | (Optional) Defines the allocation method for this IP address. Possible values are Static or Dynamic. Defaults to Dynamic. | `string` | `"Dynamic"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to the DNS zone | `map(string)` | `{}` | no |
| <a name="input_size"></a> [size](#input\_size) | (Required) The SKU which should be used for this Virtual Machine, such as Standard\_F2. | `string` | n/a | yes |
| <a name="input_source_image_reference"></a> [source\_image\_reference](#input\_source\_image\_reference) | A source\_image\_reference block. | <pre>object({<br>    publisher = string<br>    offer     = string<br>    sku       = string<br>    version   = string<br>  })</pre> | n/a | yes |
| <a name="input_os_disk"></a> [os\_disk](#input\_os\_disk) | An os\_disk block. | <pre>object({<br>    caching              = string<br>    storage_account_type = string<br>    diff_disk_settings = optional(object({<br>      option    = string<br>      placement = optional(string, "CacheDisk")<br>    }))<br>    disk_encryption_set_id           = optional(string)<br>    disk_size_gb                     = optional(number)<br>    name                             = optional(string)<br>    secure_vm_disk_encryption_set_id = optional(string)<br>    security_encryption_type         = optional(string)<br>    write_accelerator_enabled        = optional(bool, false)<br>  })</pre> | n/a | yes |
| <a name="input_admin_username"></a> [admin\_username](#input\_admin\_username) | Username of the administrative account on the virtual machine | `string` | n/a | yes |
| <a name="input_length"></a> [length](#input\_length) | Admin password generation | `number` | `24` | no |
| <a name="input_number"></a> [number](#input\_number) | n/a | `bool` | `true` | no |
| <a name="input_special"></a> [special](#input\_special) | n/a | `bool` | `false` | no |
| <a name="input_network_map"></a> [network\_map](#input\_network\_map) | Map of spoke networks where vnet name is key, and value is object containing attributes to create a network | <pre>map(object({<br>    resource_group_name = optional(string)<br>    location            = optional(string)<br>    vnet_name           = optional(string)<br>    address_space       = list(string)<br>    subnet_names        = list(string)<br>    subnet_prefixes     = list(string)<br>    bgp_community       = string<br>    ddos_protection_plan = object(<br>      {<br>        enable = bool<br>        id     = string<br>      }<br>    )<br>    dns_servers                                           = list(string)<br>    nsg_ids                                               = map(string)<br>    route_tables_ids                                      = map(string)<br>    subnet_delegation                                     = map(map(any))<br>    subnet_enforce_private_link_endpoint_network_policies = map(bool)<br>    subnet_enforce_private_link_service_network_policies  = map(bool)<br>    subnet_service_endpoints                              = map(list(string))<br>    tags                                                  = map(string)<br>    tracing_tags_enabled                                  = bool<br>    tracing_tags_prefix                                   = string<br>    use_for_each                                          = bool<br>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_public_ip_id"></a> [public\_ip\_id](#output\_public\_ip\_id) | The ID of this Public IP. |
| <a name="output_public_ip_name"></a> [public\_ip\_name](#output\_public\_ip\_name) | The Name of this Public IP. |
| <a name="output_ip_address"></a> [ip\_address](#output\_ip\_address) | The IP address value that was allocated. |
| <a name="output_fqdn"></a> [fqdn](#output\_fqdn) | Fully qualified domain name of the A DNS record associated with the public IP. domain\_name\_label must be specified to get the fqdn. This is the concatenation of the domain\_name\_label and the regionalized DNS zone |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | Name of the resource group to be created. |
| <a name="output_virtual_machine_id"></a> [virtual\_machine\_id](#output\_virtual\_machine\_id) | ID of the virtual machine to be created. |
| <a name="output_virtual_machine_name"></a> [virtual\_machine\_name](#output\_virtual\_machine\_name) | Name of the virtual machine to be created. |
| <a name="output_virtual_machine_public_ip_address"></a> [virtual\_machine\_public\_ip\_address](#output\_virtual\_machine\_public\_ip\_address) | IP Address of the virtual machine to be created. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
