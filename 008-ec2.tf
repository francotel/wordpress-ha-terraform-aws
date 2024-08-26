# ################################################################################
# # EC2 Module
# ################################################################################


# module "ec2_b_2" {
#   source  = "terraform-aws-modules/ec2-instance/aws"
#   version = "5.6.1"

#   name                        = "ec2-vpc-b-2-${var.env}"
#   instance_type               = "t3a.micro"
#   subnet_id                   = element(module.vpc_b_2.private_subnets, 0)
#   vpc_security_group_ids      = [aws_security_group.web_sg_b_2.id]
#   user_data                   = file("apache-config.sh")
#   user_data_replace_on_change = true

#   create_iam_instance_profile = true
#   iam_role_description        = "IAM role for EC2 instance"
#   iam_role_policies = {
#     AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
#   }
#   metadata_options = {
#     http_tokens = "required"
#   }
# }
