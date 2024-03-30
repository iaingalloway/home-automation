#!/bin/bash

set -e

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <machine_name>"
  exit 1
fi

MACHINE_NAME=$1
MACHINE_IP=$(dig +short $MACHINE_NAME | head -n 1)
if [ -z "$MACHINE_IP" ]; then
  echo "Failed to resolve IP for $MACHINE_NAME. Please check your network or DNS settings."
  exit 1
fi

echo "Using machine name: $MACHINE_NAME"
echo "Using machine IP: $MACHINE_IP"

echo "Backing up the existing kubeconfig file..."
cp ~/.kube/config ~/.kube/config-backup

echo "Retrieving kubeconfig file from the server..."
scp ${MACHINE_NAME}:/etc/rancher/k3s/k3s.yaml ~/.kube/config-pi

echo "Replacing localhost with the server IP..."
sed -i "s/127.0.0.1/${MACHINE_IP}/" ~/.kube/config-pi

echo "Renaming the context..."
sed -i "s/default/${MACHINE_NAME}/" ~/.kube/config-pi

echo "Merging kubeconfig files..."
export KUBECONFIG=~/.kube/config:~/.kube/config-pi
kubectl config view --flatten > ~/.kube/config-flattened
cp ~/.kube/config-flattened ~/.kube/config
export KUBECONFIG=~/.kube/config

echo "Testing the new configuration..."
kubectl config get-contexts
kubectl config use-context ${MACHINE_NAME}
kubectl cluster-info

echo "Kubeconfig is updated and merged successfully."
