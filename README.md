# homecluster
My home k8s cluster IaC

## WIP

Currently this is a single-node kubeadm managed k8s cluster running on a constantly updating latest
release of Ubuntu (21.10 to start) and latest version of K8s.


# Initialization

Install docker and kubeadm, init the cluster, add Calico. As root:

```bash
bin/install-docker.sh
bin/install-kubeadm.sh
kubeadm init --pod-network-cidr "10.222.0.0/16"
export KUBECONFIG=/etc/kubernetes/admin.conf
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
```
