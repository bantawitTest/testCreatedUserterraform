name: Terraform Plan and Apply

on:
  pull_request:
    paths:
      - terraform.tfvars  # Ejecutar solo si hay cambios en terraform.tfvars
    branches:
      - main  # Solo para pull requests dirigidos a la rama main

permissions:
  id-token: write
  contents: read

jobs:
  terraform:
    runs-on: ubuntu-latest

    steps:
      # Paso 1: Checkout del código del repositorio
      - name: Checkout code
        uses: actions/checkout@v2

      # Paso 2: Verificar si terraform.tfvars ha cambiado
      - name: Check if terraform.tfvars has changed
        id: check_tfvars
        run: |
          git fetch origin main
          if ! git diff --quiet origin/main -- terraform.tfvars; then
            echo "terraform.tfvars has changed, proceeding with the workflow"
          else
            echo "No changes detected in terraform.tfvars, skipping workflow."
            exit 0  # Skip the workflow if no changes in terraform.tfvars
          fi

      # Paso 3: Instalar Terraform
      - name: Set up Terraform
        uses: hashicorp/setup-terraform@v1
        with:
          terraform_version: '1.5.0'  # Cambia a la versión de Terraform que necesitas
          terraform_wrapper: false  # Deshabilita el script envoltorio

      # Paso 4: Configurar las credenciales de AWS OIDC (suponiendo que AWS OIDC esté configurado con GitHub)
      - name: Set up AWS OIDC credentials
        uses: aws-actions/configure-aws-credentials@v1
        with:
          role-to-assume: arn:aws:iam::$account_id:role/GitHubActionsRole
          aws-region: us-east-1
          role-session-name: GitHubActions

      # Paso 5: Inicializar Terraform
      - name: Terraform Init
        run: terraform init

      # Paso 6: Aplicar Terraform y capturar las salidas
      - name: Terraform Apply
        id: apply
        run: |
          terraform apply -auto-approve
          echo "::notice title=Terraform Apply Completed::Successfully applied Terraform changes"
          
          # Capturar las salidas de Terraform y exportarlas como variables de entorno
          echo "USER_NAME=$(terraform output -raw user_name)" >> $GITHUB_ENV
          echo "ACCESS_KEY_ID=$(terraform output -raw access_key_id)" >> $GITHUB_ENV
          echo "ACCESS_KEY_SECRET=$(terraform output -raw access_key_secret)" >> $GITHUB_ENV

      # Paso 7: Crear el archivo con la información del usuario
      - name: Create User Info File
        run: |
          echo "Buenas tardes," > user_info.txt
          echo "" >> user_info.txt
          echo "Se ha creado el usuario con los siguientes datos:" >> user_info.txt
          echo "User name: $USER_NAME" >> user_info.txt
          echo "Access key id: $ACCESS_KEY_ID" >> user_info.txt
          echo "Access secret key: $ACCESS_KEY_SECRET" >> user_info.txt
          echo "" >> user_info.txt
          echo "Recordad que hay que pegar esta clave en el campo seguro." >> user_info.txt
          echo "" >> user_info.txt
          echo "Un saludo." >> user_info.txt

      # Paso 8: Subir el archivo como un artefacto
      - name: Upload User Info as Artifact
        uses: actions/upload-artifact@v3
        with:
          name: user-info
          path: user_info.txt
          retention-days: 1
