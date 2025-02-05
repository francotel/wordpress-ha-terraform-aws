# Despliegue de un WordPress en Alta Disponibilidad con Terraform en AWS

Este repositorio contiene un flujo de trabajo básico para desplegar un entorno de WordPress en alta disponibilidad en AWS utilizando Terraform y Makefile. La configuración está orientada a facilitar la gestión y despliegue de recursos, permitiendo ejecutar los comandos de Terraform de forma más sencilla.

## 🚀 Funcionalidades

- **Automatización con Makefile:** Comandos para inicializar, validar, planificar, aplicar y destruir recursos en AWS con Terraform.
- **Gestión de recursos en AWS:** Configuración para despliegue de redes, bases de datos, almacenamiento y más.
- **Reportes de costos:** Generación de reportes de costos con Infracost para visualizar el impacto financiero de la infraestructura antes de su implementación.

## 🖼️ Arquitectura del Proyecto

A continuación, se muestra un diagrama de la arquitectura del despliegue:

![Arquitectura](images/wordpress-ha-aws.png)

## 📋 Requisitos

- [Terraform](https://www.terraform.io/downloads.html) instalado.
- [AWS CLI](https://aws.amazon.com/cli/) configurado con perfiles de autenticación.
- [Make](https://www.gnu.org/software/make/) instalado.
- [Infracost](https://www.infracost.io/docs/) configurado para análisis de costos.

## 📂 Estructura del Repositorio

La estructura del repositorio organiza los recursos por tipo para una fácil navegación:


## 🔧 Configuración Inicial

### 1. Clonar el repositorio

Primero, clona el repositorio en tu máquina local:

```bash
git clone https://github.com/francotel/wordpress-ha-terraform-aws.git
cd wordpress-ha-terraform-aws
```

## ⚙️ Uso

# Terraform Makefile - Caso de Uso

Este Makefile facilita la administración de infraestructura con Terraform mediante comandos simples y reutilizables.

## Configuración

Antes de ejecutar los comandos, asegúrate de actualizar las siguientes variables en el Makefile:

- `AWS_PROFILE`: Nombre del perfil de AWS a utilizar.
- `AWS_REGION`: Región en la que se desplegarán los recursos.

Ejemplo:

```makefile
AWS_PROFILE ?= mi-perfil-aws
AWS_REGION ?= us-east-1
```

## Comandos Disponibles

### Inicialización y validación:
```sh
make tf-init
```

### Planificación:
```sh
make tf-plan
```

### Aplicación del plan:
```sh
make tf-apply
```

### Destrucción de recursos:
```sh
make tf-destroy
```

### Visualización de salidas:
```sh
make tf-output
```

### Estimación de costos con Infracost:
```sh
make infracost
```

### Generación de reporte HTML de costos:
```sh
make infracost-html
```

Este Makefile optimiza el flujo de trabajo de Terraform, asegurando consistencia en cada ejecución.

## 📝 Notas
Asegúrate de definir correctamente los perfiles de AWS y ajustar las variables de Terraform según tu entorno.
El despliegue se ha probado en la región us-west-1, pero se puede adaptar a otras regiones ajustando las variables y configuraciones.

## 📢 ¡Sígueme y Apóyame!

Si encuentras útil este repositorio y quieres ver más contenido similar, ¡sígueme en LinkedIn para estar al tanto de más proyectos y recursos!

[![LinkedIn](https://content.linkedin.com/content/dam/me/business/en-us/amp/brand-site/v2/bg/LI-Logo.svg.original.svg)](https://www.linkedin.com/in/franconavarro/)


Si deseas apoyar mi trabajo, puedes invitarme a un café. ¡Gracias por tu apoyo!

[![BuyMeACoffee](https://github.com/francotel/wordpress-ha-terraform-aws/blob/main/images/buymeacoffee.png)](https://www.buymeacoffee.com/francotel)