### AWS TRANSIT ###
module "aws_trans" {
  source        = "terraform-aviatrix-modules/aws-transit/aviatrix"
  version       = "4.0.0"
  name          = "aws-transit"
  cidr          = var.aws_transit_cidr
  region        = var.aws_transit_region
  account       = var.aws_aviatrix_account_name
  instance_size = var.aws_transit_size
  ha_gw         = var.aws_transit_ha
  insane_mode   = var.aws_insane_mode
}

### AWS IPERF CLIENT GW  ###

module "aws_client_spoke" {
  source        = "terraform-aviatrix-modules/aws-spoke/aviatrix"
  version       = "4.0.1"
  name          = "aws-client"
  cidr          = var.aws_iperf_client_cidr
  region        = var.aws_client_gw_src_region
  account       = var.aws_aviatrix_account_name
  transit_gw    = module.aws_trans.transit_gateway.gw_name
  instance_size = var.aws_client_gw_src_size
  ha_gw         = var.aws_client_spoke_ha
  insane_mode   = var.aws_insane_mode
}

### AWS IPERF SERVERS GW ###

module "aws_server_spoke" {
  source        = "terraform-aviatrix-modules/aws-spoke/aviatrix"
  version       = "4.0.1"
  name          = "aws-server"
  cidr          = var.aws_iperf_server_cidr
  region        = var.aws_server_gw_dst_region
  account       = var.aws_aviatrix_account_name
  transit_gw    = module.aws_trans.transit_gateway.gw_name
  instance_size = var.aws_server_gw_dst_size
  ha_gw         = var.aws_server_spoke_ha
  insane_mode   = var.aws_insane_mode
}

### AWS LINUX SERVER ###

module "awsserver" {
  count  = var.aws_server_num_iperf
  source = "git::https://github.com/fkhademi/terraform-aws-instance-module.git?ref=v1.5-firenet"

  name          = "server${count.index}"
  region        = var.aws_server_gw_dst_region
  vpc_id        = module.aws_server_spoke.vpc.vpc_id
  subnet_id     = count.index % 2 == 0 ? module.aws_server_spoke.vpc.public_subnets[0].subnet_id : module.aws_server_spoke.vpc.public_subnets[1].subnet_id
  ssh_key       = var.ssh_key
  user_data     = data.template_file.cloudconfig.rendered
  # user_data     = data.template_file.cloudconfig_server[count.index].rendered
  public_ip     = true
  instance_size = var.aws_server_iperf_size
  depends_on    = [ module.aws_server_spoke ]
}

### LINUX CLIENT ###
module "awsclient" {
  count  = var.aws_client_num_iperf
  source = "git::https://github.com/fkhademi/terraform-aws-instance-module.git?ref=v1.5-firenet"

  name          = "client${count.index}"
  region        = var.aws_client_gw_src_region
  vpc_id        = module.aws_client_spoke.vpc.vpc_id
  subnet_id     = count.index % 2 == 0 ? module.aws_client_spoke.vpc.public_subnets[0].subnet_id : module.aws_client_spoke.vpc.public_subnets[1].subnet_id
  ssh_key       = var.ssh_key
  user_data     = data.template_file.cloudconfig.rendered
  # user_data     = data.template_file.cloudconfig[count.index].rendered
  public_ip     = true
  instance_size = var.aws_client_iperf_size
  depends_on    = [ module.aws_client_spoke ]
}

### ADD AWS CLIENTS TO DNS  - default lab.mihai.tech ###

data "aws_route53_zone" "awslinuxdns" {
  name         = var.domain_name
  private_zone = false
}

resource "aws_route53_record" "awsclient" {
  count   = var.aws_client_num_iperf
  zone_id = data.aws_route53_zone.awslinuxdns.zone_id
  name    = "aws-client${count.index}.${data.aws_route53_zone.awslinuxdns.name}"
  type    = "A"
  ttl     = "1"
  records = [module.awsclient[count.index].vm.public_ip]
}

resource "aws_route53_record" "awsclient-int" {
  count   = var.aws_client_num_iperf
  zone_id = data.aws_route53_zone.awslinuxdns.zone_id
  name    = "aws-client${count.index}-priv.${data.aws_route53_zone.awslinuxdns.name}"
  type    = "A"
  ttl     = "1"
  records = [module.awsclient[count.index].vm.private_ip]
}

resource "aws_route53_record" "awsserver" {
  count   = var.aws_server_num_iperf
  zone_id = data.aws_route53_zone.awslinuxdns.zone_id
  name    = "aws-server${count.index}.${data.aws_route53_zone.awslinuxdns.name}"
  type    = "A"
  ttl     = "1"
  records = [module.awsserver[count.index].vm.public_ip]
}

resource "aws_route53_record" "awsserver-int" {
  count   = var.aws_server_num_iperf
  zone_id = data.aws_route53_zone.awslinuxdns.zone_id
  name    = "aws-server${count.index}-priv.${data.aws_route53_zone.awslinuxdns.name}"
  type    = "A"
  ttl     = "1"
  records = [module.awsserver[count.index].vm.private_ip]
}


### AZURE TRANSIT ###
module "azure_trans" {
  source        = "terraform-aviatrix-modules/azure-transit/aviatrix"
  version       = "4.0.0"
  name          = "azure-transit"
  cidr          = var.azure_transit_cidr
  region        = var.azure_transit_region
  account       = var.azure_aviatrix_account_name
  instance_size = var.azure_transit_size
  ha_gw         = var.azure_transit_ha
  insane_mode   = var.azure_insane_mode
}


#### AZURE IPERF CLIENT GW  ###

module "azure_client_spoke" {
  source        = "terraform-aviatrix-modules/azure-spoke/aviatrix"
  version       = "4.0.1"
  name          = "azure-client"
  cidr          = var.azure_iperf_client_cidr
  region        = var.azure_client_gw_src_region
  account       = var.azure_aviatrix_account_name
  transit_gw    = module.azure_trans.transit_gateway.gw_name
  instance_size = var.azure_client_gw_src_size
  ha_gw         = var.azure_client_spoke_ha
  insane_mode   = var.azure_insane_mode
}

### AZURE IPERF SERVERS GW ###

module "azure_server_spoke" {
  source        = "terraform-aviatrix-modules/azure-spoke/aviatrix"
  version       = "4.0.1"
  name          = "azure-server"
  cidr          = var.azure_iperf_server_cidr
  region        = var.azure_server_gw_dst_region
  account       = var.azure_aviatrix_account_name
  transit_gw    = module.azure_trans.transit_gateway.gw_name
  instance_size = var.azure_server_gw_dst_size
  ha_gw         = var.azure_server_spoke_ha
  insane_mode   = var.azure_insane_mode
}

### AZURE LINUX SERVER ###

module "azureserver" {
  count  = var.azure_server_num_iperf
  source = "git::https://github.com/fkhademi/terraform-azure-instance-build-module.git?ref=v0.5-iperf"

  name          = "server${count.index}"
  region        = var.azure_server_gw_dst_region
  rg            = module.azure_server_spoke.vnet.resource_group
  vnet          = module.azure_server_spoke.vnet.name
  subnet        = count.index % 2 == 0 ? module.azure_server_spoke.vnet.public_subnets[0].subnet_id : module.azure_server_spoke.vnet.public_subnets[1].subnet_id
  ssh_key       = var.ssh_key
  cloud_init_data = data.template_file.cloudconfig.rendered
  # user_data     = data.template_file.cloudconfig_server[count.index].rendered
  public_ip     = true
  instance_size = var.azure_server_iperf_size
  depends_on    = [ module.azure_server_spoke ]
}

### AZURE LINUX CLIENT ###
module "azureclient" {
  count  = var.azure_client_num_iperf
  source = "git::https://github.com/fkhademi/terraform-azure-instance-build-module.git?ref=v0.5-iperf"

  name          = "client${count.index}"
  region        = var.azure_client_gw_src_region
  rg            = module.azure_client_spoke.vnet.resource_group
  vnet          = module.azure_client_spoke.vnet.name
  subnet        = count.index % 2 == 0 ? module.azure_client_spoke.vnet.public_subnets[0].subnet_id : module.azure_client_spoke.vnet.public_subnets[1].subnet_id
  ssh_key       = var.ssh_key
  cloud_init_data = data.template_file.cloudconfig.rendered
  # user_data     = data.template_file.cloudconfig[count.index].rendered
  public_ip     = true
  instance_size = var.azure_client_iperf_size
  depends_on    = [ module.azure_client_spoke ]
}

data "aws_route53_zone" "azurelinuxdns" {
  name         = var.domain_name
  private_zone = false
}

resource "aws_route53_record" "azureclient" {
  count   = var.azure_client_num_iperf
  zone_id = data.aws_route53_zone.azurelinuxdns.zone_id
  name    = "azure-client${count.index}.${data.aws_route53_zone.azurelinuxdns.name}"
  type    = "A"
  ttl     = "1"
  records = [module.azureclient[count.index].public_ip.ip_address]
}

resource "aws_route53_record" "azureclient-int" {
  count   = var.azure_client_num_iperf
  zone_id = data.aws_route53_zone.azurelinuxdns.zone_id
  name    = "azure-client${count.index}-priv.${data.aws_route53_zone.azurelinuxdns.name}"
  type    = "A"
  ttl     = "1"
  records = [module.azureclient[count.index].nic.private_ip_address]
}

resource "aws_route53_record" "azureserver" {
  count   = var.azure_server_num_iperf
  zone_id = data.aws_route53_zone.awslinuxdns.zone_id
  name    = "azure-server${count.index}.${data.aws_route53_zone.azurelinuxdns.name}"
  type    = "A"
  ttl     = "1"
  records = [module.azureserver[count.index].public_ip.ip_address]
}

resource "aws_route53_record" "azureserver-int" {
  count   = var.azure_server_num_iperf
  zone_id = data.aws_route53_zone.azurelinuxdns.zone_id
  name    = "azure-server${count.index}-priv.${data.aws_route53_zone.azurelinuxdns.name}"
  type    = "A"
  ttl     = "1"
  records = [module.azureserver[count.index].nic.private_ip_address]
}

## INSTALL IPERF and NTTTCP + netperf on VMs ###
data "template_file" "cloudconfig" {
  template = file("${path.module}/generic.tpl")
}

### TRANSIT PEERING ####

resource "aviatrix_transit_gateway_peering" "avx_azure_transit_gateway_peering" {
  transit_gateway_name1               = module.aws_trans.transit_gateway.gw_name
  transit_gateway_name2               = module.azure_trans.transit_gateway.gw_name
  enable_insane_mode_encryption_over_internet = var.transit_peering_insane
  tunnel_count                        = 16
}



# last test
# in output.tf you can put under a variable sensitive = true to NOT have its value printed in the DEBUG output
