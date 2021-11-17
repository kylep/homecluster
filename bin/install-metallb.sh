#!/bin/bash

if [[ "$1" == "" ]]; then
  echo "ERROR: Need to pass CIDR range as arg"
  echo "Ex:    '10.105.254.101-10.105.254.110'"
  exit 1
fi

addr_range=$1
outfile="./metallb-config.yaml"
echo "Generating $outfile with address range $addr_range"

cat > $outfile << EOH
piVersion: v1
kind: ConfigMap
metadata:
  namespace: metallb-system
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
kubectl apply -f $outfile

echo rm $outfile
rm $outfile
