# Configuração de DNS para API Escolar

## Opções de Configuração

### 1. Desenvolvimento Local

**Para testes locais:**
```bash
# Adicionar ao /etc/hosts (Linux/Mac) ou C:\Windows\System32\drivers\etc\hosts (Windows)
127.0.0.1 api-escolar.local
```

**Aplicar configuração:**
```bash
kubectl apply -f k8s/ingress.yaml
```

### 2. Produção com SSL Manual

**Passos:**
1. Obter certificado SSL para `api-escolar.com.br`
2. Criar secret com o certificado:
```bash
kubectl create secret tls api-escolar-tls \
  --cert=certificate.crt \
  --key=private.key \
  -n gestao-escolar
```

3. Aplicar configuração:
```bash
kubectl apply -f k8s/ingress-prod.yaml
```

### 3. Produção com Cert-Manager (Recomendado)

**Instalar Cert-Manager:**
```bash
# Helm
helm repo add jetstack https://charts.jetstack.io
helm repo update
helm install cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --set installCRDs=true

# Ou kubectl
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.13.0/cert-manager.yaml
```

**Configurar ClusterIssuer:**
```yaml
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    email: seu-email@exemplo.com
    privateKeySecretRef:
      name: letsencrypt-prod
    solvers:
    - http01:
        ingress:
          class: nginx
```

**Aplicar configuração:**
```bash
kubectl apply -f cluster-issuer.yaml
kubectl apply -f k8s/ingress-cert-manager.yaml
```

## Configuração de DNS

### Para Produção:

1. **Registrar domínio** `api-escolar.com.br` em um provedor de DNS
2. **Configurar registros A** apontando para o IP do Load Balancer:
   ```
   api-escolar.com.br.  A  <IP_DO_LOAD_BALANCER>
   ```

3. **Obter IP do Load Balancer:**
   ```bash
   kubectl get svc -n ingress-nginx
   ```

### Para Desenvolvimento:

1. **Usar Minikube:**
   ```bash
   minikube addons enable ingress
   minikube tunnel
   ```

2. **Usar Kind:**
   ```bash
   # Configurar ingress controller
   kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
   ```

## Verificação

```bash
# Verificar status do Ingress
kubectl get ingress -n gestao-escolar

# Verificar certificados (se usando Cert-Manager)
kubectl get certificates -n gestao-escolar

# Testar acesso
curl -H "Host: api-escolar.com.br" http://localhost
```

## Troubleshooting

### Problemas Comuns:

1. **Namespace inconsistente:**
   - Verificar se todos os recursos estão no mesmo namespace

2. **SSL não funciona:**
   - Verificar se o secret do certificado existe
   - Verificar se o Cert-Manager está funcionando

3. **DNS não resolve:**
   - Verificar configuração do provedor de DNS
   - Aguardar propagação (pode levar até 48h)

4. **Ingress não funciona:**
   - Verificar se o Ingress Controller está instalado
   - Verificar logs do Ingress Controller 