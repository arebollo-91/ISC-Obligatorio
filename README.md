ISC-Obligatorio - IS en AWS con Terraform
# ISC Obligatorio – Infraestructura en AWS con Terraform

Este repositorio contiene la infraestructura de una aplicación web simple desplegada en AWS utilizando Terraform.  
La solución incluye red propia (VPC, subredes públicas y privadas), balanceo de carga, instancias web con Docker/Nginx, base de datos RDS, bucket de backups en S3, Auto Scaling Group y monitoreo básico con CloudWatch.

---

## 1. Instructivo de uso del repositorio

### 1.1. Estructura de carpetas

ISC-Obligatorio/
├── Terraform/        # Código de infraestructura (archivos .tf)
├── docs/             # Documentación adicional (PDF/MD)
└── diagrams/         # Diagramas de arquitectura (PNG, draw.io, etc.)

Dentro de Terraform/ se encuentran:

providers.tf – configuración del provider de AWS.

variables.tf – definición de variables (región, perfil, credenciales DB, etc.).

network.tf – VPC, subredes, route tables, IGW, NAT.

security-groups.tf – grupos de seguridad y reglas asociadas.

lb.tf – Application Load Balancer, Target Group y listeners.

EC2.tf – instancias web y Auto Scaling Group.

db.tf – RDS MySQL y subnet group.

backup.tf – bucket S3, versioning y lifecycle.

monitoring.tf – alarmas de CloudWatch.

outputs.tf – outputs útiles (IDs, DNS, endpoints, etc.).

terraform.tfvars – valores concretos de variables (no versionado en Git).

### 1.2. Configuración de credenciales AWS

Se asume que las credenciales se obtienen desde el entorno de laboratorio (por ejemplo, con el botón “Show credentials” del lab) y se configuran con AWS CLI:

aws configure
AWS Access Key ID: <access_key>
AWS Secret Access Key: <secret_key>
Default region name: us-east-1
Default output format: json


Terraform usará ese perfil (default) a través del provider "aws".

### 1.3. Configurar variables sensibles

En Terraform/variables.tf se declaran variables como:

db_username

db_password

(opcionalmente) otras como vpc_cidr, public_subnet_a, etc.

Los valores se cargan en un archivo terraform.tfvars que no se sube a Git.
Ejemplo (no copiar tal cual a producción):

region      = "us-east-1"
perfil_admin = "default"

db_username = "admin"
db_password = "cambiar_esta_contraseña"


Importante: mantener terraform.tfvars fuera del repositorio (.gitignore lo excluye).

### 1.4. Inicialización y despliegue

Desde ISC-Obligatorio/Terraform:

terraform init        # Descarga providers y prepara el backend local
terraform validate    # Valida sintaxis y referencias
terraform plan        # Muestra qué recursos se van a crear/modificar
terraform apply       # Crea o actualiza la infraestructura
Escribir: yes

Al finalizar el apply se mostrarán los outputs definidos (por ejemplo, DNS del ALB, endpoint de RDS, IDs de subredes).

### 1.6. Pruebas manuales básicas

Una vez desplegada la infra:

#### Acceso HTTP a través del ALB

Usar el output del ALB (o verlo en la consola)

Navegar a:
http://<dns_del_alb>

Debe aparecer la página por defecto de Nginx.

<img width="975" height="247" alt="image" src="https://github.com/user-attachments/assets/8028089c-597a-4967-a5a8-48596becc9bd" />

#### Acceso SSH a las instancias web

Desde tu PC:

cd C:\Users\<usuario>\.ssh
ssh -i labsuser.pem ec2-user@<IP_PUBLICA_WEB>

Validar que se puede entrar como ec2-user.

<img width="975" height="491" alt="image" src="https://github.com/user-attachments/assets/47f11967-ced6-495d-a7e5-32331be41cf7" />

#### Conectividad entre web y base de datos RDS

Desde una instancia web:

mysql -h <db_endpoint> -u <db_username> -p
SHOW DATABASES;
USE isc_app_db;

<img width="413" height="279" alt="image" src="https://github.com/user-attachments/assets/cdef88da-6c29-4a93-bc37-d5f4108767f1" />

#### Bloqueo de acceso directo a la DB desde Internet

Desde tu PC:

Test-NetConnection <db_endpoint> -Port 3306

Debe fallar, no accesible directamente desde Internet.

<img width="975" height="338" alt="image" src="https://github.com/user-attachments/assets/2d645475-981e-4ebb-ac1f-016cacf3a0f7" />

#### Tolerancia a fallos en la capa web

Verificar en el Target Group que las instancias están healthy.

Detener una instancia web desde EC2.

Volver a abrir el DNS del ALB: la página de Nginx debe seguir respondiendo.

<img width="975" height="479" alt="image" src="https://github.com/user-attachments/assets/ef7d5609-87c5-43f8-85df-1339945e50e2" />

#### Backups en S3

Activar la vista de versiones.

Ver la regla de Lifecycle que mueve los objetos a Glacier después de 30 días.

<img width="678" height="422" alt="image" src="https://github.com/user-attachments/assets/0bb04f06-64a4-4fbe-9438-f54313877a09" />
<img width="975" height="549" alt="image" src="https://github.com/user-attachments/assets/d06f2b89-03a3-4c3d-bb52-8d362596699c" />

## 2. Dependencias y requerimientos
### 2.1. Herramientas

Terraform: versión 1.0 o superior (desarrollado con Terraform 1.x).

Provider AWS: hashicorp/aws versión ~> 5.0.

AWS CLI: v2 (para configurar credenciales y comprobar recursos).

Git: para clonar y versionar el repositorio.

Cliente MySQL/MariaDB (en las instancias web) para pruebas con RDS.

Docker: instalado automáticamente vía user_data en las instancias web.

### 2.2. Requerimientos de AWS

Cuenta/lab de AWS con permisos para:

EC2, VPC, Subnets, Internet Gateway, NAT Gateway, Elastic IP.

Elastic Load Balancing (Application Load Balancer).

RDS (MySQL).

S3.

Auto Scaling.

CloudWatch (métricas y alarmas).

Región utilizada: us-east-1.

## 3. Datos de la infraestructura

### 3.1. Red (VPC, subnets, ruteo)

- **VPC del proyecto**
  - Nombre/tag: `isc-vpc`
  - CIDR: `10.0.0.0/16`

- **Subredes públicas**
  - `public_a` – AZ `us-east-1a`, CIDR `10.0.1.0/24`, `map_public_ip_on_launch = true`
  - `public_b` – AZ `us-east-1b`, CIDR `10.0.2.0/24`, `map_public_ip_on_launch = true`

- **Subredes privadas**
  - `private_a` – AZ `us-east-1a`, CIDR `10.0.3.0/24`, `map_public_ip_on_launch = false`
  - `private_b` – AZ `us-east-1b`, CIDR `10.0.4.0/24`, `map_public_ip_on_launch = false`

- **Ruteo**
  - Route table pública: `0.0.0.0/0 → Internet Gateway`, asociada a `public_a` y `public_b`.
  - Route table privada: `0.0.0.0/0 → NAT Gateway` (en `public_a`), asociada a `private_a` y `private_b`.

### 3.2. Capa de cómputo (instancias web + ASG)

- **Instancias web “fijas” (histórico / pruebas)**
  - `web1` en `public_a`, `web2` en `public_b`.
  - Tipo `t3.micro`, AMI Amazon Linux 2023, `key_name = "vockey"`, IP pública.
  - `user_data`: actualiza el sistema, instala y arranca Docker y levanta un contenedor `nginx` en el puerto 80.

- **Launch Template web (ASG)**
  - Misma AMI y tipo (`t3.micro`), `key_name = "vockey"`, `vpc_security_group_ids = [isc-web-sg]`.
  - `user_data` con la misma lógica: instalar Docker y desplegar Nginx en el puerto 80 de forma automática.

- **Auto Scaling Group**
  - Nombre: `isc-web-asg`, `min_size = 2`, `desired_capacity = 2`, `max_size = 4`.
  - `vpc_zone_identifier = [public_a, public_b]` (instancias distribuidas en dos AZ).
  - Asociado al Target Group del ALB: las instancias del ASG se registran y deregistran automáticamente.

### 3.3. Capa de base de datos

- **Amazon RDS MySQL**
  - Recurso: `aws_db_instance.app_db`, motor MySQL 8.0, clase `db.t3.micro`, 20 GB iniciales.
  - `multi_az = true`, `publicly_accessible = false`.
  - Subnet group con `private_a` y `private_b`.
  - Security Group `isc-db-sg`: solo acepta `3306/TCP` desde `isc-web-sg`.
  - Backups automáticos: `backup_retention_period = 7` días.
  - Credenciales: `db_name = "isc_app_db"`, usuario y contraseña definidos vía `terraform.tfvars`.

### 3.4. Balanceo de carga y acceso externo

- **Application Load Balancer (ALB)**
  - Público (`internal = false`), en `public_a` y `public_b`.
  - Security Group `isc-alb-sg`: HTTP 80 desde Internet.

- **Target Group y listener**
  - Target Group tipo `instance`, puerto `80/TCP`, health check HTTP:
    - `interval = 30`, `healthy_threshold = 3`, `unhealthy_threshold = 3`,
    - `path = "/"`, `matcher = "200-399"`.
  - Listener HTTP en puerto 80 con acción por defecto `forward` a `isc-web-tg`.

### 3.5. Backups y almacenamiento

- **Bucket S3 de backups**
  - Recurso: `aws_s3_bucket.backups`.
  - Versionado habilitado (`aws_s3_bucket_versioning.backups_versioning`).
  - Lifecycle (`aws_s3_bucket_lifecycle_configuration.backups_lifecycle`):
    - transición a **S3 Glacier** a los 30 días,
    - expiración de objetos a los 365 días (valores ajustables).

### 3.6. Seguridad / firewalling (Security Groups)

- **SG ALB – `isc-alb-sg`**
  - Inbound: HTTP 80/TCP desde `0.0.0.0/0`.
  - Outbound: todo permitido (`0.0.0.0/0`).

- **SG web – `isc-web-sg`**
  - Inbound:
    - HTTP 80/TCP solo desde `isc-alb-sg` (todo tráfico a la app pasa por el ALB).
    - SSH 22/TCP desde `0.0.0.0/0` (solo para laboratorio; en producción se restringiría).
  - Outbound: todo permitido (acceso a RDS, S3, updates, etc.).

- **SG DB – `isc-db-sg`**
  - Inbound: MySQL 3306/TCP únicamente desde `isc-web-sg`.
  - Outbound: todo permitido.

- **Flujo de red resumido**
  - Internet → ALB (HTTP 80)  
  - ALB → instancias web (HTTP 80, SG ALB → SG web)  
  - Instancias web → RDS (MySQL 3306, SG web → SG db)

### 3.7. Escalabilidad

- Capa web stateless (Nginx en contenedores Docker).
- Auto Scaling Group:
  - permite aumentar o reducir el número de instancias web ajustando `desired_capacity` o agregando políticas basadas en métricas (por ejemplo, CPU).
  - nuevas instancias se inicializan automáticamente a partir del Launch Template, instalando Docker y Nginx sin intervención manual.
- ALB + Target Group reparten el tráfico entre instancias en distintas AZ y dejan de usar instancias marcadas como `unhealthy` por los health checks.

### 3.8. Monitoreo

- **Alarmas en CloudWatch (`aws_cloudwatch_metric_alarm`)**
  - Instancias web:
    - métrica `CPUUtilization` (`AWS/EC2`), dimensión `InstanceId`,
    - umbral ~70 % de CPU promedio durante varios períodos.
  - Base de datos RDS:
    - métrica `CPUUtilization` (`AWS/RDS`), dimensión `DBInstanceIdentifier`.
- En esta etapa las alarmas no disparan notificaciones, pero dejan preparada la integración futura con SNS, dashboards y políticas de autoescalado basadas en métricas.

## 4. Servicios de AWS utilizados

Resumen de los servicios de AWS que intervienen en la solución:

Amazon VPC

VPC, subredes públicas y privadas, route tables.

Internet Gateway, NAT Gateway, Elastic IP.

Amazon EC2

Instancias web (tipo t3.micro).

Instancia de administración (en la VPC por defecto del lab).

Elastic Load Balancing (ALB)

Application Load Balancer público.

Target Group HTTP con health checks.

Amazon RDS

Base de datos MySQL Multi-AZ en subredes privadas.

Amazon S3

Bucket de backups.

Versionado y lifecycle (Glacier + expiración).

AWS Auto Scaling

Auto Scaling Group para la capa web.

Launch Template con user_data para instalar Docker y desplegar Nginx.

Amazon CloudWatch

Métricas de EC2 y RDS.

Alarmas de CPU para capa web y base de datos.

## 5. Posibles mejoras

1. **Pasar el acceso a HTTPS**
   Actualmente el acceso es por HTTP (puerto 80). Una mejora sería agregar un certificado de AWS Certificate Manager (ACM) y exponer la aplicación por HTTPS (puerto 443) a través del ALB, cifrando el tráfico entre los usuarios y la aplicación.

2. **Restringir más el acceso por SSH**
   En el entorno de laboratorio el puerto 22 está abierto a `0.0.0.0/0`. En un entorno real se podría limitar el SSH solo a la IP de administración o a una VPN, reduciendo la superficie de ataque.

3. **Alertas por mail de las alarmas de CloudWatch**
   Las alarmas de CPU de EC2 y RDS hoy solo se ven en la consola. Como mejora se podría crear un tópico SNS y configurar las alarmas para que envíen un correo cuando se dispare una alerta.

4. **Guardar logs del ALB y de la aplicación**
   Otra mejora sería habilitar los access logs del ALB hacia un bucket S3 y enviar los logs de las instancias (Nginx / sistema) a CloudWatch Logs. Eso facilitaría el análisis de errores y auditoría del tráfico.
