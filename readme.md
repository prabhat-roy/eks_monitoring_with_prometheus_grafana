Create kubernets cluster using eksctl

eksctl create cluster --name EKS-Cluster --region ap-south-2 --nodegroup-name eks-worker-nodes --node-type t3.medium --managed --nodes 2 

Update kubeconfig to connect kubernetes cluster

aws eks update-kubeconfig --region ap-south-2 --name EKS-Cluster

Run terraform apply -auto-approve to create EKS cluster

Add the Helm Stable Charts forlocal client.
helm repo add stable https://charts.helm.sh/stable

Add prometheus Helm repo
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

Create monitoring namespace
kubectl create namespace monitoring

Install prometheus and grafana
helm install stable prometheus-community/kube-prometheus-stack -n monitoring

Lets check if prometheus and grafana pods are running already
kubectl get pods -n monitoring
kubectl get svc -n monitoring

Edit both service to change to LoadBalancer from ClusterIP to get available outside of the cluster
kubectl edit svc stable-kube-prometheus-sta-prometheus -n monitoring
kubectl edit svc stable-grafana -n monitoring

Verify if service is changed to LoadBalancer and also to get the Load Balancer URL.
kubectl get svc -n monitoring

Get the URL from the grafana service and put in the browser
UserName: admin 
Password: prom-operator

Create Kubernetes Monitoring Dashboard
Click '+' button on left panel and select ‘Import’.
Enter 12740 dashboard id under Grafana.com Dashboard.
Click ‘Load’.
Select ‘Prometheus’ as the endpoint under prometheus data sources drop down.
Click ‘Import’.

Create Kubernetes Cluster Monitoring Dashboard
Click '+' button on left panel and select ‘Import’.
Enter 3119 dashboard id under Grafana.com Dashboard.
Click ‘Load’.
Select ‘Prometheus’ as the endpoint under prometheus data sources drop down.
Click ‘Import’

Create POD Monitoring Dashboard
Click '+' button on left panel and select ‘Import’.
Enter 6417 dashboard id under Grafana.com Dashboard.
Click ‘Load’.
Select ‘Prometheus’ as the endpoint under prometheus data sources drop down.
Click ‘Import’.