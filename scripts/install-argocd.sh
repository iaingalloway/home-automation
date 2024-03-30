#!/bin/bash

set -e

SCRIPT_DIR="$(dirname "$0")"

ARGOCD_PATH="${SCRIPT_DIR}/../manifests/argocd"

echo Installing Argo CD...
kubectl apply -n argocd -k "$ARGOCD_PATH"

echo Waiting for Argo CD...
kubectl wait --namespace argocd --for=condition=available deploy argocd-server --timeout=5m
kubectl wait --namespace argocd --for=condition=ready pod -l app.kubernetes.io/name=argocd-server --timeout=5m
