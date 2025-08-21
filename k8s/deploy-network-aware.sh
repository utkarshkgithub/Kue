#!/bin/bash

# Network-Aware Deployment Script for Kue Blog
# This script deploys the application with Nginx load balancer

set -e

echo "🚀 Starting Network-Aware Deployment for Kue Blog..."

# Function to check if a resource exists
check_resource() {
    kubectl get $1 $2 -n default &>/dev/null
}

# Function to wait for deployment to be ready
wait_for_deployment() {
    echo "⏳ Waiting for $1 to be ready..."
    kubectl wait --for=condition=available --timeout=300s deployment/$1 -n default
}

# Function to wait for pods to be ready
wait_for_pods() {
    echo "⏳ Waiting for $1 pods to be ready..."
    kubectl wait --for=condition=ready --timeout=300s pods -l app=$1 -n default
}

echo "📋 Step 1: Installing Nginx Ingress Controller (if not exists)..."
if ! kubectl get namespace ingress-nginx &>/dev/null; then
    echo "Installing Nginx Ingress Controller..."
    kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.1/deploy/static/provider/cloud/deploy.yaml
    
    echo "⏳ Waiting for Nginx Ingress Controller to be ready..."
    kubectl wait --namespace ingress-nginx \
        --for=condition=ready pod \
        --selector=app.kubernetes.io/component=controller \
        --timeout=300s
else
    echo "✅ Nginx Ingress Controller already exists"
fi

echo "📋 Step 2: Applying Database Secret (if not exists)..."
if ! check_resource secret db-credentials; then
    echo "⚠️  Database secret not found. Please create it first:"
    echo "kubectl create secret generic db-credentials \\"
    echo "  --from-literal=PGHOST=your-db-host \\"
    echo "  --from-literal=PGDATABASE=blogdb \\"
    echo "  --from-literal=PGUSER=your-db-user \\"
    echo "  --from-literal=PGPASSWORD=your-db-password \\"
    echo "  --from-literal=PGPORT=5432"
    echo ""
    read -p "Press Enter after creating the secret to continue..."
fi

echo "📋 Step 3: Deploying Core Application..."
kubectl apply -f kub.yaml
wait_for_deployment cloud-blog
wait_for_pods cloud-blog

echo "📋 Step 4: Deploying Nginx Load Balancer..."
kubectl apply -f nginx-loadbalancer.yaml
wait_for_deployment nginx-lb
wait_for_pods nginx-lb

echo "📋 Step 5: Applying Network Policies..."
kubectl apply -f network-policy.yaml

echo "📋 Step 6: Setting up Horizontal Pod Autoscaling..."
# Check if metrics server is running
if ! kubectl top nodes &>/dev/null; then
    echo "⚠️  Metrics server not found. Installing..."
    kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
    echo "⏳ Waiting for metrics server to be ready..."
    sleep 30
fi

kubectl apply -f hpa.yaml

echo "📋 Step 7: Getting Service Information..."
echo ""
echo "🎉 Deployment Complete!"
echo ""
echo "📊 Deployment Status:"
kubectl get deployments -n default
echo ""
echo "🌐 Services:"
kubectl get services -n default
echo ""
echo "📈 HPA Status:"
kubectl get hpa -n default
echo ""
echo "🔗 Ingress:"
kubectl get ingress -n default
echo ""

# Get LoadBalancer IP
EXTERNAL_IP=""
echo "⏳ Waiting for LoadBalancer IP..."
while [ -z $EXTERNAL_IP ]; do
    echo "Waiting for external IP..."
    EXTERNAL_IP=$(kubectl get svc nginx-lb-service --template="{{range .status.loadBalancer.ingress}}{{.ip}}{{end}}")
    [ -z "$EXTERNAL_IP" ] && sleep 10
done

echo "✅ LoadBalancer IP: $EXTERNAL_IP"
echo ""
echo "🌍 Your application is now available at:"
echo "   http://$EXTERNAL_IP"
echo ""
echo "🔍 Health Check:"
echo "   curl http://$EXTERNAL_IP/health"
echo ""
echo "📊 Monitoring commands:"
echo "   kubectl get pods -l app=cloud-blog"
echo "   kubectl get pods -l app=nginx-lb"
echo "   kubectl top pods"
echo "   kubectl describe hpa"
echo ""
echo "🚀 Network-aware deployment completed successfully!"
