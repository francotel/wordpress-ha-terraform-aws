tf_version = "1.9.3"
env        = "demo"
project    = "wordpress-ha"
owner      = "franco.navarro"
cost       = "0001-wp-demo"

####   VARIABLES VPC   ####

vpcs = {
  main_vpc = {
    cidr             = "172.16.0.0/16"
    private_subnets  = ["172.16.0.0/24", "172.16.1.0/24"]
    public_subnets   = ["172.16.2.0/24", "172.16.3.0/24"]
    database_subnets = ["172.16.4.0/24", "172.16.5.0/24"]
  }
}

####   DOMAIN R53   #####
domain = "crosscloudx.com"