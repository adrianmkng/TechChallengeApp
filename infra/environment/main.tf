module "network" {
  source = "../modules//network"

  name     = var.name
  vpc_cidr = var.vpc_cidr
  zones    = ["a"]
}

