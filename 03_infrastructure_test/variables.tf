## Variable definitons


variable REGION {
  type        = string
  default     = ""
  description = "The Azure region to create resources in."
}

variable RG_TEST_NAME {
  type        = string
  default     = ""
  description = "Name of the Resource Group."
}

variable RG_TEST_NAME {
  type        = string
  default     = ""
  description = "Name of the Resource Group."
}

variable VNET_TEST_NAME {
  type        = string
  default     = ""
  description = "Name of the Virtual Network."
}

variable SUBNET_TEST_NAME {
  type        = string
  default     = ""
  description = "Name of the Subnet."
}

variable PUBLIC_IP_TEST_NAME {
  type        = string
  default     = ""
  description = "Name of the public IPs."
}

variable NSG_TEST_NAME {
  type        = string
  default     = ""
  description = "Name of the Network Security Group."
}

variable NIC_TEST_NAME {
  type        = string
  default     = ""
  description = "Name of the Network Interface."
}

variable VM_TEST_NAME {
  type        = string
  default     = ""
  description = "Name of the Virtual Machine."
}


# Tag variables


variable TAGS_TEST{
  type    = map(string)
  default = {
    application = "test"
    created_by  = "terraform"
  }
}

 