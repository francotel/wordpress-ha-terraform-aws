SHELL := /usr/bin/env bash
.EXPORT_ALL_VARIABLES:

demo:
	$(eval AWS_PROFILE   = $(shell echo "orion-aws"))
	$(eval AWS_REGION    = $(shell echo "us-west-1"))

# HOW TO EXECUTE

# Executing Terraform PLAN
#	$ make tf-plan env=<env>
#       make tf-plan env=dev

# Executing Terraform APPLY
#   $ make tf-apply env=<env>

# Executing Terraform DESTROY
#	$ make tf-destroy env=<env>
	
#####  TERRAFORM  #####
all-test: clean tf-plan

.PHONY: clean tf-output tf-init tf-plan tf-apply tf-destroy
	rm -rf .terraform

tf-init: $(env)
	terraform init -reconfigure -upgrade && terraform validate 

tf-plan: $(env)
	terraform fmt --recursive && terraform validate && terraform plan -var-file *.tfvars -out=tfplan

tf-apply: $(env)
	terraform fmt --recursive && terraform validate && terraform apply -auto-approve --input=false tfplan

tf-destroy: $(env)
	terraform destroy -var-file *.tfvars

tf-output: $(env)
	AWS_PROFILE=${AWS_PROFILE} terraform output