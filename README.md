# Home automation

This repo contains the code for my home automation system. It is based on k3s on a Raspberry Pi 5 using ArgoCD.

## Features

- [x] k3s
- [x] ArgoCD
- [x] Prometheus
- [x] Grafana
- [ ] Home Assistant
- [ ] Others?

## Prerequisites

- Raspberry Pi - I used a Raspberry Pi 5 with a 32GB SD card

## Setup

### Install Pi OS Lite

Use the [Raspberry Pi Imager](https://www.raspberrypi.org/software/) to install Pi OS Lite.

### Install k3s

SSH into the Raspberry Pi to disable swap and enable cgroups:

```bash
sudo swapoff -a
sudo sed -i '/^CONF_SWAPSIZE=/c\CONF_SWAPSIZE=0' /etc/dphys-swapfile
echo $(cat /boot/firmware/cmdline.txt) cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory | sudo tee /boot/firmware/cmdline.txt
sudo reboot
```

Then install k3s:

```bash
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --write-kubeconfig-mode 644" sh -
```

You can now get the kubeconfig file from the server using the following utility script on your local machine:

```bash
./scripts/merge-kubeconfig.sh %%MACHINE_NAME%%
```

### Install ArgoCD

Install ArgoCD using the utility script:

```bash
./scripts/install-argocd.sh
```

### Install app-of-apps

Install the app-of-apps:

```bash
kubectl apply -n argocd -f ./manifests/app-of-apps.yaml
```

## Cheat sheet

### Pi

Pi OS Lite comes with network preconfigured by the imaging tool. To edit network settings (e.g. Wifi) use:

```bash
sudo nmtui
```

### ArgoCD

To port-forward the ArgoCD server to your local machine:

```bash
k port-forward svc/argocd-server -n argocd 8080:80
```

To port-forward Grafana to your local machine:

```bash
k port-forward -n monitoring svc/kube-prometheus-stack-grafana 8081:80
```

To port-forward Home Assistant to your local machine:

```bash
k port-forward -n home-assistant svc/home-assistant 8082:8080
```

## See also

- [Raspberry Pi](https://www.raspberrypi.org/)
- [ArgoCD](https://argoproj.github.io/argo-cd/)
- [k3s](https://k3s.io/)
- [Prometheus](https://prometheus.io/)
- [Grafana](https://grafana.com/)
- [Home Assistant](https://www.home-assistant.io/)
