module "networking1" {
  source                 = "./networking"
  region                 = var.region
  public_subnet_az1_cidr = "10.31.1.0/24"
  vpc_cidr               = "10.31.0.0/16"
  project_name           = "geoserver1"
}

module "networking2" {
  source                 = "./networking"
  region                 = var.region
  public_subnet_az1_cidr = "10.30.1.0/24"
  vpc_cidr               = "10.30.0.0/16"
  project_name           = "geoserver2"
}

module "iam" {
  source       = "./iam"
  project_name = var.project_name
  region       = var.region
}

module "geoserver1" {
  source            = "./compute"
  security_group_id = module.networking1.security_group_id
  instance_profile  = module.iam.instance_profile
  subnet_id         = module.networking1.subnet_id
  ssh_key_pair      = var.ssh_key_pair
  instance_type     = var.instance_type
  ami_id            = var.ami_id
  host_os           = var.host_os
  region            = var.region
  project_name      = "geoserver1"

}

module "geoserver2" {
  source            = "./compute"
  security_group_id = module.networking2.security_group_id
  instance_profile  = module.iam.instance_profile
  subnet_id         = module.networking2.subnet_id
  ssh_key_pair      = var.ssh_key_pair
  instance_type     = var.instance_type
  ami_id            = var.ami_id
  host_os           = var.host_os
  region            = var.region
  project_name      = "geoserver2"
}