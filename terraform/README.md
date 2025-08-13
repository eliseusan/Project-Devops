# Terraform - Google Artifact Registry

Este diretório contém os arquivos Terraform para criar um Google Artifact Registry para a API Escolar.

## Pré-requisitos

1. **Terraform instalado** (versão >= 1.0)
2. **Google Cloud SDK** configurado
3. **Projeto Google Cloud** criado
4. **Service Account** com permissões adequadas

## Configuração

### 1. Autenticação no Google Cloud

```bash
# Faça login no Google Cloud
gcloud auth application-default login

# Configure o projeto
gcloud config set project SEU_PROJECT_ID
```

### 2. Configurar as variáveis

```bash
# Copie o arquivo de exemplo
cp terraform.tfvars.example terraform.tfvars

# Edite o arquivo com seus valores
nano terraform.tfvars
```

Preencha as seguintes variáveis:
- `project_id`: ID do seu projeto Google Cloud
- `region`: Região onde criar o registry (padrão: us-central1)
- `zone`: Zona do Google Cloud (padrão: us-central1-a)
- `service_account_email`: Email da service account com acesso ao registry

### 3. Inicializar o Terraform

```bash
# Primeira execução - criar o bucket e recursos
terraform init

# Após a primeira execução, migrar para o backend remoto
terraform init -migrate-state
```

### 4. Verificar o plano

```bash
terraform plan
```

### 5. Aplicar a configuração

```bash
terraform apply
```

## Recursos Criados

- **Google Artifact Registry**: Repositório Docker para armazenar imagens
- **Google Cloud Storage Bucket**: Bucket para armazenar o state do Terraform
- **IAM Permissions**: Permissões de leitura e escrita para a service account
- **API Enablement**: Habilitação das APIs do Artifact Registry e Cloud Storage

## Usando o Registry

Após a criação, você pode usar o registry para fazer push/pull de imagens Docker:

### Autenticação no Docker

```bash
# Configure o Docker para usar o Google Cloud
gcloud auth configure-docker REGION-docker.pkg.dev
```

### Exemplos de comandos

```bash
# Fazer tag da imagem
docker tag api-escolar:latest REGION-docker.pkg.dev/PROJECT_ID/api-escolar-repo/api-escolar:latest

# Fazer push da imagem
docker push REGION-docker.pkg.dev/PROJECT_ID/api-escolar-repo/api-escolar:latest

# Fazer pull da imagem
docker pull REGION-docker.pkg.dev/PROJECT_ID/api-escolar-repo/api-escolar:latest
```

## Outputs

Após a aplicação, o Terraform mostrará:
- `repository_id`: ID do repositório
- `repository_name`: Nome completo do repositório
- `repository_url`: URL para push/pull de imagens
- `docker_tag_example`: Exemplo de comando para tag
- `docker_push_example`: Exemplo de comando para push

## Backend Remoto

Este projeto está configurado para usar um backend remoto no Google Cloud Storage. O state file será salvo no bucket `terraform-state-api-escolar` com as seguintes características:

- **Versionamento habilitado**: Para backup e recuperação
- **Lifecycle rules**: Mantém apenas as últimas 30 versões
- **Uniform bucket-level access**: Para melhor segurança
- **Proteção contra exclusão**: O bucket não pode ser excluído acidentalmente

### Estrutura do State

O state será salvo no caminho:
```
gs://terraform-state-api-escolar/artifact-registry/default.tfstate
```

### Trabalhando com o Backend Remoto

1. **Primeira execução**: O Terraform criará o bucket e migrará o state automaticamente
2. **Execuções subsequentes**: O state será carregado automaticamente do bucket
3. **Trabalho em equipe**: Múltiplos desenvolvedores podem trabalhar no mesmo projeto

## Limpeza

Para remover todos os recursos criados:

```bash
terraform destroy
```

**⚠️ Atenção**: O bucket do state não será excluído automaticamente para proteger contra perda de dados. Para excluí-lo manualmente:

```bash
# Remover a proteção primeiro
terraform state rm google_storage_bucket.terraform_state

# Então executar destroy novamente
terraform destroy
```

## Permissões Necessárias

A service account precisa das seguintes permissões:
- `roles/artifactregistry.reader`
- `roles/artifactregistry.writer`
- `roles/storage.admin` (para o bucket do state)
- `roles/storage.objectViewer`
- `roles/storage.objectCreator`

## Troubleshooting

### Erro de permissão
Se você receber erro de permissão, verifique se:
1. A service account existe
2. A service account tem as permissões necessárias
3. O projeto está correto

### Erro de API não habilitada
Se a API do Artifact Registry ou Cloud Storage não estiverem habilitadas, o Terraform irá habilitá-las automaticamente.

### Erro de backend
Se você receber erro relacionado ao backend, verifique se:
1. O bucket foi criado corretamente
2. A service account tem permissões no bucket
3. O nome do bucket está correto no arquivo `main.tf`

### Migração do state
Para migrar o state local para o backend remoto:
```bash
terraform init -migrate-state
```
