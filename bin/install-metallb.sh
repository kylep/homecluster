#!/bin/bash

if [[ "$1" == "" ]]; then
  echo "ERROR: Need to pass CIDR range as arg"
  echo "Ex:    '10.105.254.101-10.105.254.110'"
  exit 1
fi

addr_range=$1
outfile="./metallb-config.yaml"
namespace="metallb-system"
echo "Generating $outfile with address range $addr_range"

cat > $outfile << EOH
apiVersion: v1
kind: ConfigMap
metadata:
  namespace: $namespace
  name: config
data:
  config: |
    address-pools:
    - name: default
      protocol: layer2
      addresses:
      - $addr_range
EOH

kubectl create namespace $namespace
kubectl apply -f $outfile

# I don't get why the helm+values.yaml approach doesn't work for me, oh well
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.5/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.5/manifests/metallb.yaml
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"


echo rm $outfile
rm $outfile
