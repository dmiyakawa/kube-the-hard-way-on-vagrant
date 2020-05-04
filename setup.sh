#!/bin/bash

export KUBE_VERSION=v1.18.2

MYPATH=$(readlink -f $0)
WORKDIR=$(dirname $mypath)

wget -q --show-progress --https-only --timestamping https://storage.googleapis.com/kubernetes-release/release/${KUBE_VERSION}/bin/darwin/amd64/kubectl -O ${WORKDIR}/bin/kubectl
wget -q --show-progress --https-only --timestamping https://storage.googleapis.com/kubernetes-the-hard-way/cfssl/linux/cfssl -O ${WORKDIR}/bin/cfssl
wget -q --show-progress --https-only --timestamping https://storage.googleapis.com/kubernetes-the-hard-way/cfssl/linux/cfssljson -O ${WORKDIR}/bin/cfssljson

chmod +x ${WORKDIR}/bin/kubectl ${WORKDIR}/bin/cfssl ${WORKDIR}/bin/cfssljson
