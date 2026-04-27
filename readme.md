# EKS Monitoring with Prometheus + Grafana (Terraform + Helm)

Provisions an AWS EKS cluster and walks through installing the kube-prometheus-stack Helm chart (Prometheus, Alertmanager, Grafana, node-exporter, kube-state-metrics) for full cluster observability.

---

## What gets created

| Resource | File |
|---|---|
| VPC + subnets + IGW + NAT | `vpc.tf`, `subnet.tf`, `igw.tf`, `nat.tf`, `route-table.tf` |
| EKS control plane | `eks.tf` |
| Managed worker node group | `worker-node.tf`, `launch-template.tf` |
| IAM roles + policies | `iam.tf` |
| Security groups | `sg.tf` |
| Sample workload to monitor | `deployment.yaml` |

The `kube-prometheus-stack` chart is installed manually after the cluster is up (commands in this README).

---

## Prerequisites

1. AWS Administrator credential.
2. EC2 key pair.
3. Terraform >= 1.5, kubectl, helm.

---

## Deploy

### 1. Stand up the cluster

```bash
terraform init
terraform apply -auto-approve

aws eks update-kubeconfig --region ap-south-2 --name EKS-Cluster
kubectl get nodes
```

(Or stand it up faster with `eksctl`:)

```bash
eksctl create cluster \
  --name EKS-Cluster \
  --region ap-south-2 \
  --nodegroup-name eks-worker-nodes \
  --node-type t3.medium \
  --managed --nodes 2
```

### 2. Install kube-prometheus-stack

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
kubectl create namespace monitoring

helm install monitoring prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --set prometheus.service.type=LoadBalancer \
  --set grafana.service.type=LoadBalancer \
  --set alertmanager.service.type=LoadBalancer
```

### 3. Get URLs

```bash
kubectl get svc -n monitoring
```

Open Grafana on the printed external LoadBalancer hostname. Default credentials: `admin / prom-operator`.

### 4. Default dashboards

The chart preloads dashboards for: cluster overview, node usage, namespace usage, pod-level CPU/memory, kube-API-server, etcd, kubelet, scheduler, controller-manager, CoreDNS.

---

## Tear down

```bash
helm uninstall monitoring -n monitoring
kubectl delete namespace monitoring
terraform destroy -auto-approve
```