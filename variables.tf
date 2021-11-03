# SSH key for instances
variable "ssh_key" { }

# AVX Cloud Accounts
variable "aviatrix_admin_account" { default = "" }
variable "aviatrix_admin_password" { }
variable "aviatrix_controller_ip" { default = "" }
variable "azure_aviatrix_account_name" { default = "" }
variable "aws_aviatrix_account_name" { default = "" }

# AWS - global params + TRANSIT
variable "aws_transit_region" { default = "eu-central-1" }
variable "aws_access" { }
variable "aws_secret" { }
variable "aws_transit_size" { default = "c5n.xlarge" }
variable "aws_transit_cidr" { default = "10.10.0.0/23" }
variable "aws_iperf_client_cidr" { default = "10.10.2.0/23" }
variable "aws_iperf_server_cidr" { default = "10.10.4.0/23" }
variable "aws_insane_mode" { default = false }
variable "aws_transit_ha" { default = false }

# CLIENT SPOKE
variable "aws_client_gw_src_size" { default = "c5n.xlarge" }
variable "aws_client_spoke_ha" { default = false }
variable "aws_client_gw_src_region"{ default = "eu-central-1" }

# SERVER SPOKE
variable "aws_server_gw_dst_size" { default = "c5n.xlarge" }
variable "aws_server_spoke_ha" { default = false }
variable "aws_server_gw_dst_region" { default = "eu-central-1" }

# AWS Linux Server
variable "aws_server_num_iperf" { default = 4 }
variable "aws_server_iperf_size" { default = "c5n.xlarge" }

# AWS Linux Client
variable "aws_client_num_iperf" { default = 4 }
variable "aws_client_iperf_size" { default = "c5n.xlarge" }

# DNS AWS/Azure Linux Client/Servers 
variable "domain_name" { default = "" }

################## END AWS ###############################

# AZURE- global params + TRANSIT
variable "azure_appId" { }
variable "azure_password" { }
variable "azure_tenant" { }
variable "azure_subscription_id" { }
variable "azure_transit_region" { default = "West Europe" }
variable "azure_transit_size" { default = "Standard_F48s_v2" }
variable "azure_transit_cidr" { default = "10.20.0.0/23" }
variable "azure_iperf_client_cidr" { default = "10.20.2.0/23" }
variable "azure_iperf_server_cidr" { default = "10.20.4.0/23" }
variable "azure_insane_mode" { default = false }
variable "azure_transit_ha" { default = false }

# CLIENT SPOKE
variable "azure_client_gw_src_size" { default = "Standard_F48s_v2" }
variable "azure_client_spoke_ha" { default = false }
variable "azure_client_gw_src_region"{ default = "West Europe" }

# SERVER SPOKE
variable "azure_server_gw_dst_size" { default = "Standard_F48s_v2" }
variable "azure_server_spoke_ha" { default = false }
variable "azure_server_gw_dst_region" { default = "West Europe" }

# AZURE Linux Server
variable "azure_server_num_iperf" { default = 4 }
variable "azure_server_iperf_size" { default = "Standard_F48s_v2" }

# AZURE Linux Client
variable "azure_client_num_iperf" { default = 4 }
variable "azure_client_iperf_size" { default = "Standard_F48s_v2" }

####### END AZURE ###########################################

### TRANSITS PEERING ##

variable "transit_peering_insane" { default = true }

