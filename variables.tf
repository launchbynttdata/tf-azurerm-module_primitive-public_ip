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

variable "name" {
  type        = string
  description = "(Required) Specifies the name of the Public IP. Changing this forces a new Public IP to be created."
}

variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the resource group in which to create the Public IP. Changing this forces a new resource to be created."
}

variable "location" {
  type        = string
  description = "(Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
}

variable "allocation_method" {
  type        = string
  description = "(Optional) Defines the allocation method for this IP address. Possible values are Static or Dynamic. Defaults to Static."
  default     = "Static"

  validation {
    condition     = contains(["Static", "Dynamic"], var.allocation_method)
    error_message = "allocation_method must be either Static or Dynamic."
  }
}

variable "zones" {
  type        = list(string)
  description = "(Optional) A collection containing the availability zone to allocate the Public IP in. Changing this forces a new resource to be created."
  default     = []
}

variable "ddos_protection_mode" {
  type        = string
  description = "(Optional) The DDoS protection mode of the public IP. Possible values are Disabled, Enabled, and VirtualNetworkInherited. Defaults to VirtualNetworkInherited."
  default     = "VirtualNetworkInherited"

  validation {
    condition     = contains(["Disabled", "Enabled", "VirtualNetworkInherited"], var.ddos_protection_mode)
    error_message = "ddos_protection_mode must be one of Disabled, Enabled, or VirtualNetworkInherited."
  }
}

variable "ddos_protection_plan_id" {
  type        = string
  description = "(Optional) The Resource ID of the DDoS protection plan to associate with this Public IP. Changing this forces a new resource to be created."
  default     = null
}

variable "domain_name_label" {
  type        = string
  description = "(Optional) Label for the Domain Name. Will be used to make up the FQDN. If a domain name label is specified, an A DNS record is created for the public IP in the Microsoft Azure DNS system."
  default     = null
}

variable "edge_zone" {
  type        = string
  description = "(Optional) Specifies the Edge Zone within the Azure Region where this Public IP should exist. Changing this forces a new Public IP to be created."
  default     = null
}

variable "idle_timeout_in_minutes" {
  type        = number
  description = "(Optional) The timeout for the TCP idle connection. The value can be set between 4 and 30 minutes. The default value is 4 minutes. Changing this forces a new resource to be created."
  default     = 4
}

variable "ip_tags" {
  type        = map(string)
  description = "(Optional) A mapping of IP tags to assign to the Public IP."
  default     = {}
}

variable "ip_version" {
  type        = string
  description = "(Optional) The IP Version to use, IPv6 or IPv4. Defaults to IPv4."
  default     = "IPv4"

  validation {
    condition     = contains(["IPv4", "IPv6"], var.ip_version)
    error_message = "ip_version must be either IPv4 or IPv6."
  }
}

variable "public_ip_prefix_id" {
  type        = string
  description = "(Optional) If specified then public IP address allocated will be provided from the public IP prefix resource. Changing this forces a new resource to be created."
  default     = null
}

variable "reverse_fqdn" {
  type        = string
  description = "(Optional) The Reverse FQDN (fully qualified domain name) for this Public IP. Changing this forces a new resource to be created."
  default     = null
}

variable "sku" {
  type        = string
  description = "(Optional) The SKU of the Public IP. Possible values are Basic, Standard, and StandardV2. Defaults to Standard."
  default     = "Standard"

  validation {
    condition     = contains(["Basic", "Standard", "StandardV2"], var.sku)
    error_message = "sku must be one of Basic, Standard, or StandardV2."
  }
}

variable "sku_tier" {
  type        = string
  description = "(Optional) The SKU tier to use for the Public IP. Possible values are Regional and Global. Defaults to Regional."
  default     = "Regional"

  validation {
    condition     = contains(["Regional", "Global"], var.sku_tier)
    error_message = "sku_tier must be either Regional or Global."
  }
}

variable "tags" {
  type        = map(string)
  description = "(Optional) A mapping of tags to assign to the resource."
  default     = {}
}
