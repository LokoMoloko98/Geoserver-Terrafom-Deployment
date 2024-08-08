module "networking" {
  source                 = "./networking"
  region                 = var.region
  public_subnet_az1_cidr = var.public_subnet_az1_cidr
  vpc_cidr               = var.vpc_cidr
  project_name           = var.project_name
}

module "iam" {
  source       = "./iam"
  project_name = var.project_name
  region       = var.region
}

module "compute" {
  source            = "./compute"
  security_group_id = module.networking.security_group_id
  instance_profile  = module.iam.instance_profile
  subnet_id         = module.networking.subnet_id
  ssh_key_pair      = var.ssh_key_pair
  instance_type     = var.instance_type
  ami_id            = var.ami_id
  host_os           = var.host_os
  region            = var.region
  project_name      = var.project_name

}