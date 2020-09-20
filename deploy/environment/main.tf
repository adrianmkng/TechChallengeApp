module "network" {
  source = "../modules//network"

  name     = var.name
  vpc_cidr = var.vpc_cidr
  zones    = ["a", "b"]
}

module "database" {
  source = "../modules//postgres"

  name          = var.db_name
  db_username   = var.db_username
  db_password   = var.db_password
  vpc_id        = module.network.vpc.id
  subnet_ids    = module.network.private_subnets.*.id
  trusted_cidrs = module.network.private_subnets.*.cidr_block

}

