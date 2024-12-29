name: Terraform Plan and Apply

on:
  push:
    branches:
      - main
permissions:
  id-token: write
  contents: read

jobs:
  terraform:
    runs-on: ubuntu-latest

    steps:
      # Step 1: Checkout the repository code
      - name: Checkout code
        uses: actions/checkout@v2

      # Step 2: Install Terraform
      - name: Set up Terraform
        uses: hashicorp/setup-terraform@v1
        with:
          terraform_version: '1.5.0'  # Change to the version of Terraform you need

      # Step 3: Set up AWS OIDC credentials (Assuming AWS OIDC is configured with GitHub)
      - name: Set up AWS OIDC credentials
        uses: aws-actions/configure-aws-credentials@v1
        with:
          role-to-assume: arn:aws:iam::918691367691:role/GithubActionWorkflowOICD
          aws-region: us-east-1
          role-session-name: GitHubActions

      # Step 4: Terraform Init
      - name: Terraform Init
        run: terraform init

      # Step 5: Terraform Apply and Capture Output
      - name: Terraform Apply
        id: apply
        run: |
          terraform apply -auto-approve
          echo "::notice title=Terraform Apply Completed::Successfully applied Terraform changes"
          
          # Capture the Terraform output values and store them in environment variables
          USER_NAME=$(terraform output -raw user_name)
          ACCESS_KEY_ID=$(terraform output -raw access_key_id)
          ACCESS_KEY_SECRET=$(terraform output -raw access_key_secret)
          
          # Crear el archivo con los valores extraídos
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


      # Step 6: Upload the file as an artifact
      - name: Upload User Info as Artifact
        uses: actions/upload-artifact@v3
        with:
          name: user-info
          path: user_info.txt