output "vpc_id" {
  description = "ID de la VPC creada"
  value       = module.networking.vpc_id
}

output "private_subnets" {
  description = "IDs de las subredes privadas"
  value       = module.networking.private_subnets
}

output "public_subnets" {
  description = "IDs de las subredes públicas"
  value       = module.networking.public_subnets
}

output "kms_key_alias" {
  description = "Alias de la clave KMS"
  value       = values(module.kms.aliases)[0].name
}

output "kms_key_arn" {
  description = "ARN de la clave KMS"
  value       = module.kms.key_arn
}

output "efs_id" {
  description = "ID del sistema de archivos EFS"
  value       = module.efs.id
}

output "efs_arn" {
  description = "ARN del sistema de archivos EFS"
  value       = module.efs.arn
}

output "efs_dns" {
  description = "DNS del sistema de archivos EFS"
  value       = module.efs.dns_name
}

output "elasticache_cluster_endpoint" {
  description = "Endpoint del cluster de Elasticache"
  value       = module.elasticache.cluster_configuration_endpoint
}

output "db_aurora_hostname" {
  description = "Identificador de la instancia RDS"
  value       = module.aurora.cluster_endpoint
}

output "db_aurora_name" {
  description = "Endpoint de la base de datos RDS"
  value       = module.aurora.cluster_database_name
}

output "acm_arn_clodufront" {
  description = "ARN del certificado ACM Cloudfront"
  value       = module.acm_cloudfront.acm_certificate_arn
}

output "acm_arn_alb" {
  description = "ARN del certificado ACM ALB"
  value       = module.acm.acm_certificate_arn
}

output "alb_dns_name" {
  description = "Nombre DNS del ALB"
  value       = module.alb.dns_name
}

output "alb_arn" {
  description = "ARN del ALB"
  value       = module.alb.id
}

output "asg_name" {
  description = "Nombre del Auto Scaling Group"
  value       = module.asg.autoscaling_group_name
}

output "cloudfront_distribution_id" {
  description = "ID de la distribución de CloudFront"
  value       = module.cdn.cloudfront_distribution_id #.id
}

output "cloudfront_domain_name" {
  description = "Nombre de dominio de CloudFront"
  value       = module.cdn.cloudfront_distribution_domain_name
}
