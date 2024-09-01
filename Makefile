# Exporta todas las variables definidas en el Makefile
.EXPORT_ALL_VARIABLES:

# Variables globales
AWS_PROFILE ?= scc-aws
AWS_REGION ?= us-west-1

# HOW TO EXECUTE:
# - Ejecutar PLAN: make tf-plan env=dev
# - Ejecutar APPLY: make tf-apply env=dev
# - Ejecutar DESTROY: make tf-destroy env=dev

.PHONY: clean tf-init tf-plan tf-apply tf-destroy tf-output

# Limpia los archivos generados
clean:
	rm -rf .terraform tfplan

# Inicializa Terraform y valida la configuración
tf-init:
	terraform init -reconfigure -upgrade
	terraform validate

# Ejecuta plan, valida y formatea el código
tf-plan: tf-init
	terraform fmt --recursive
	terraform validate
	terraform plan -var-file *.tfvars -out=tfplan

# Aplica el plan generado
tf-apply:
	terraform fmt --recursive
	terraform validate
	terraform apply -auto-approve -input=false tfplan

# Destruye los recursos creados
tf-destroy:
	@terraform destroy -var-file *.tfvars -auto-approve

# Muestra los outputs de Terraform
tf-output:
	@terraform output

# Genera un reporte de costos con Infracost
infracost: tf-plan
	infracost breakdown --path tfplan

# Genera un reporte de costos con Infracost HTML
infracost-html: tf-plan
	infracost breakdown --path . --format html > cost-report.html | open -a "Google Chrome" cost-report.html