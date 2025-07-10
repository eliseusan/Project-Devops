# Deploy da API Escolar no Kubernetes

Este diretório contém todos os arquivos necessários para fazer o deploy da API Escolar no Kubernetes.

## 📁 Estrutura dos Arquivos

- `namespace.yaml` - Namespace dedicado para a aplicação
- `configmap.yaml` - Configurações da aplicação
- `persistent-volume-claim.yaml` - Volume persistente para o banco SQLite
- `deployment.yaml` - Deployment da aplicação
- `service.yaml` - Service para expor a aplicação
- `ingress.yaml` - Ingress para roteamento externo
- `deploy.sh` - Script para fazer o deploy
- `delete.sh` - Script para remover a aplicação

## 🚀 Como Fazer o Deploy

### Pré-requisitos

1. **Kubernetes cluster** configurado e funcionando
2. **kubectl** instalado e configurado
3. **Docker** para construir a imagem
4. **Ingress Controller** instalado (opcional, para o Ingress)

### Passos

1. **Construir a imagem Docker:**
   ```bash
   docker build -t api-escolar:latest .
   ```

2. **Fazer o deploy:**
   ```bash
   cd k8s
   chmod +x deploy.sh
   ./deploy.sh
   ```

3. **Verificar o status:**
   ```bash
   kubectl get all -n api-escolar
   ```

## 🌐 Como Acessar

### Via Port-Forward (Recomendado para desenvolvimento)
```bash
kubectl port-forward service/api-escolar-service 8080:80 -n api-escolar
```
Acesse: http://localhost:8080

### Via Ingress (Produção)
Se você tiver um Ingress Controller configurado, adicione a entrada no seu arquivo hosts:
```
127.0.0.1 api-escolar.local
```
Acesse: http://api-escolar.local

## 📊 Monitoramento

### Ver logs da aplicação:
```bash
kubectl logs -f deployment/api-escolar -n api-escolar
```

### Ver status dos pods:
```bash
kubectl get pods -n api-escolar
```

### Ver eventos:
```bash
kubectl get events -n api-escolar
```

## 🗑️ Como Remover

```bash
cd k8s
chmod +x delete.sh
./delete.sh
```

## ⚙️ Configurações

### ConfigMap
As configurações estão no arquivo `configmap.yaml`:
- `DATABASE_URL`: URL do banco SQLite
- `LOG_LEVEL`: Nível de log
- `API_TITLE`: Título da API
- `API_VERSION`: Versão da API

### Recursos
- **CPU**: 100m (request) / 200m (limit)
- **Memória**: 128Mi (request) / 256Mi (limit)
- **Replicas**: 2

### Health Checks
- **Liveness Probe**: `/docs` a cada 10s
- **Readiness Probe**: `/docs` a cada 5s

## 🔧 Troubleshooting

### Pod não inicia
```bash
kubectl describe pod <pod-name> -n api-escolar
```

### Problemas de conectividade
```bash
kubectl get endpoints -n api-escolar
```

### Problemas de volume
```bash
kubectl get pvc -n api-escolar
```

## 📝 Notas Importantes

1. **Banco SQLite**: O banco é persistido usando PVC. Em produção, considere usar um banco mais robusto como PostgreSQL.

2. **Imagem**: Certifique-se de que a imagem `api-escolar:latest` está disponível no cluster ou use um registry.

3. **Ingress**: O Ingress é opcional. Se não tiver um Ingress Controller, use port-forward para acessar.

4. **Escalabilidade**: Para melhor escalabilidade, considere usar um banco de dados externo em vez do SQLite. 