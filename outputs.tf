# output "vpc_ids" {
#   value = { for k, v in module.vpcs : k => v.vpc_id }
# }

# output "vpc_info" {
#   value = {
#     for vpc in module.vpcs :
#     vpc.vpc_id => {
#       cidr_block      = vpc.vpc_cidr_block
#       private_subnets = vpc.private_subnets
#     }
#   }
# }

# output "vpc_id" {
#   value = module.vpcs
# }