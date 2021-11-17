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

echo kubectl apply -f $outfile
kubectl create namespace $namespace
kubectl apply -f $outfile

helm install -n $namespace -f values.yaml metallb metallb/metallb

echo rm $outfile
rm $outfile
