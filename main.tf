# ==============================================================================
# Main Infrastructure Resources - Using Community Modules Directly
# ==============================================================================



module "infra" {
  source = "./infra"

  environment = "dev"

  region             = "eu-central-1"
  availability_zones = ["eu-central-1a", "eu-central-1b"]

  cluster_name    = "demo"
  cluster_version = "1.35"

  db_allocated_storage = 0
  db_instance_class    = "db.t4g.micro"
  db_password          = ""
  db_username          = ""

  msk_broker_instance_type   = ""
  msk_number_of_broker_nodes = 0

  node_desired_capacity = 2
  node_instance_types   = ["t4g.nano"]
  node_max_capacity     = 2
  node_min_capacity     = 2

  redis_node_type       = "cache.t3.micro"
  redis_num_cache_nodes = 1

  vpc_cidr = "10.0.0.0/16"
}








