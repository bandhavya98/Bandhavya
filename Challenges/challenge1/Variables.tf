variable "resource_group_name"{
    type = string
    default=  "Test-Rg"
}
variable "location" {
    type = string
    default =  "west europe"
}   
variable "virtual_network_name"{
    type =  string
    default = "Server Vnet"
}
variable "App_subnet_name"{
    type = string
    default = "Appsubnet"
}
variable "Web_subnet_name"{
    type = string
    default = "Websubnet"
}
variable "App_network_interface_name"{
    type =  string
    default = "App_NIC"
}
variable "Web_network_interface_name"{
    type =  string
    default = "Web_NIC"
}
variable "AppVM_Name"{
    type =  string
    default = " AppVm"
}
variable "WebVM_Name"{
    type =  string
    default = " WebVm"
}
variable "vm_size"{
    type = string
    default = "Standard_DS1_v2"
}
variable "sql_Server_Name"{
    type = string
    default = "bansqlbds"
}
variable "sql_db_Name"{
    type = string
    default = "SQLDb"
}
variable "sql_admin_login"{
    type = string
    default = "ADMIN"
}
variable "sql_admin_login_password"{
    type = string
    default = "ADMINPASSWORD"
}
variable "LB_FrontEnd_IP_name" {
    type = string
    default = "FrontEnd Ip"
}
variable "LB_Name"{
    type = string
    default = "ExtLB"
}
variable "lbtype"{
    type = string
    default = "public"
}
variable "lb_sku"{
    type = string
    default = "Standard"
}