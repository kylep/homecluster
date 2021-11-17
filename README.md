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

On single-node clusters, untaint the master so you can schedule pods on it
```
kubectl taint nodes --all node-role.kubernetes.io/master-
```

If you want to run kubectl and helm from the VM instead of setting up your kubecnofig locally,
install Helm.

```
bin/install-helm.sh
```

Add MetalLB. - First run `kubectl edit configmap -n kube-system kube-proxy` and set the
`strictARP` under `strictARP`. Then run the script while specifying the address range

```
./bin/install-metallb.sh '192.168.2.210-192.168.2.229'
```

Add the nginx ingress
```
helm repo add nginx-stable https://helm.nginx.com/stable
helm repo update
helm install nginx-ingress  nginx-stable/nginx-ingress
```
