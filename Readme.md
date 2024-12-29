# Terraform IAM User with Access Keys and Permissions Boundary

Este módulo de Terraform automatiza la creación de un usuario IAM en AWS con claves de acceso y una política de permisos (permissions boundary). Además, asigna políticas inline a los usuarios, establece una política de acceso basada en una lista de direcciones IP y proporciona las claves de acceso necesarias para interactuar con AWS.

## Funcionalidad del Módulo

Este módulo realiza las siguientes acciones:
1. **Crea una política de permisos (Permissions Boundary)** con una restricción de IP (usando un conjunto de direcciones IP especificadas).
2. **Crea un usuario IAM** utilizando la política de permisos creada previamente.
3. **Crea una política inline** asociada al usuario IAM que le permite asumir un rol especificado en AWS.
4. **Genera claves de acceso** para el usuario IAM y proporciona el `Access Key ID` y el `Secret Access Key`.

## Requisitos Previos

1. **Terraform:** Debes tener instalado Terraform en tu máquina o entorno de CI/CD.
2. **Cuenta AWS:** Este módulo necesita acceso a una cuenta AWS con permisos suficientes para crear usuarios, políticas y claves de acceso.
3. **Acceso de OIDC para GitHub Actions (si usas CI/CD):** Debes configurar el acceso OIDC de AWS con GitHub para autenticarte sin necesidad de claves de acceso estáticas.

## Estructura del Módulo

Este módulo está compuesto por varios archivos de Terraform para definir los recursos, variables, y outputs.

### Archivos Principales

1. **`main.tf`**: Contiene la definición de los recursos:
    - `aws_iam_policy` para la política de permisos.
    - `aws_iam_user` para crear el usuario IAM.
    - `aws_iam_user_policy` para la política inline.
    - `aws_iam_access_key` para crear las claves de acceso.

2. **`variables.tf`**: Contiene las variables que puedes modificar para personalizar el comportamiento del módulo, como el nombre del usuario, el ID de la cuenta de AWS, el nombre del rol y las direcciones IP.

3. **`outputs.tf`**: Define las salidas del módulo, como el nombre de usuario, el ID de clave de acceso y el secreto de clave de acceso.

4. **`provider.tf`**: Configura el proveedor AWS con la región especificada.

5. **`variables.tfvars`**: Archivo de variables que puedes personalizar con los valores específicos para tu entorno.

6. **`workflow.yml`**: Define un flujo de trabajo de GitHub Actions para ejecutar el módulo y capturar los valores de salida. El archivo se carga como un artefacto para su uso posterior.

## Configuración

A continuación se detallan las variables que puedes personalizar:

### Variables

- **`user_name`**: Nombre del usuario IAM que se creará (ejemplo: `"User_with_Oidc_4"`).
- **`role_name`**: Nombre del rol IAM que el usuario podrá asumir (ejemplo: `"AccountAutomationPro"`).
- **`account_id`**: ID de la cuenta AWS (ejemplo: `"918691367691"`).
- **`ip_addresses`**: Lista de direcciones IP para la política de whitelisting en el permissions boundary (ejemplo: `["34.50.0.0/16", "52.100.0.0/16"]`).

Puedes definir estas variables directamente en el archivo `variables.tfvars` o pasarlas como parámetros al ejecutar Terraform.

## Salidas

El módulo generará las siguientes salidas:

- **user_name**: El nombre del usuario IAM creado.
- **access_key_id**: El ID de clave de acceso del usuario.
- **access_key_secret**: El secreto de clave de acceso del usuario (marcado como sensitive).

Estas salidas se almacenan en el archivo `user_info.txt`, que se puede usar como artefacto para acceder a la información.

## Integración con GitHub Actions

Si estás usando GitHub Actions, este módulo incluye un archivo de flujo de trabajo (`workflow.yml`) que permite ejecutar Terraform en tu repositorio automáticamente.

### Configuración de GitHub Actions:

- Se configura el acceso a AWS utilizando OIDC.
- Se ejecuta `terraform apply` y se captura la salida de las variables.

### Subida de Artefactos:

- La salida se guarda en el archivo `user_info.txt` y se sube como un artefacto en GitHub, donde se puede descargar por los usuarios autorizados.
- El archivo de flujo de trabajo puede ser adaptado a tus necesidades específicas, incluyendo la personalización de la región y los roles.

## Seguridad

- **Claves de acceso sensibles**: Los valores de `access_key_secret` se marcan como sensibles en Terraform para asegurar que no se impriman en los logs.
- **Retención de artefactos**: Los artefactos generados (como el archivo `user_info.txt`) se almacenan con un tiempo de retención configurado en 1 día (ajustable).

## Contribuciones

Las contribuciones a este módulo son bienvenidas. Si deseas agregar características, arreglar errores o mejorar la documentación, por favor abre un pull request.
