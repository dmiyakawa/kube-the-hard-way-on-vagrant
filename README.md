# Kubernetes the Hard Way on Vagrant, 2020-05

The misc files when I tried "Kubernetes the Hard Way" with Vagrant + VirtualBox.
This repository is just for the record and I don't have any plan to actively maintain this.
No images are not associated. No detailed instructions are available at this moment.
So you won't be satisfied with this repo actually.. :-/

Please look at each file when you want to compare your work with someone else who was successful.

This is based on the nice tutorial with the similar theme in Japanese: https://qiita.com/t_ume/items/5d24b377e08669155639

As a notable difference, I used the latest tools (e.g. Kubernetes v1.18.2 instead of v1.15.3).
As you can expect it caused a few additional problems coming from the upgrades.

You may see some differences or improvements for those kind of cases, possibly.
Of course the term "latest" just means "latest as of writing", in 2020-05,
so my changes may not be appropriate or sufficient for you, coming from the future.

Confirmed with the following versions:

- VirtuarBox v6.1.6
- Vagrant 2.2.7
- Ubuntu 18.04.4 LTS
- Kubernetes: v1.18.2
- Containerd: 1.3.4
- runc: v1.0.0-rc10
- etcd: v3.4.7

I tried this tutorial with 32GB memory machine + i7-7700 which has sufficient power to run 7 VirtualBox VMs in total.
I encountered no problem along with the physical environment (though VT-X needed to be turned on to run VirtualBox first)


## How to use

```
$ export PATH=$(pwd)/bin:$PATH
$ vagrant up
```

## Example resultant status of constructed Kubernetes cluster

Last status would become like this.

```
$ kubectl config get-contexts
CURRENT   NAME                      CLUSTER                   AUTHINFO   NAMESPACE
*         kubernetes-the-hard-way   kubernetes-the-hard-way   admin

$ kubectl cluster-info
Kubernetes master is running at https://10.240.0.40:6443
CoreDNS is running at https://10.240.0.40:6443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.

$ kubectl get componentstatuses
NAME                 STATUS    MESSAGE             ERROR
scheduler            Healthy   ok
etcd-1               Healthy   {"health":"true"}
controller-manager   Healthy   ok
etcd-0               Healthy   {"health":"true"}
etcd-2               Healthy   {"health":"true"}

$ kubectl get nodes
NAME       STATUS   ROLES    AGE   VERSION
worker-0   Ready    <none>   11h   v1.18.2
worker-1   Ready    <none>   11h   v1.18.2
worker-2   Ready    <none>   11h   v1.18.2
```

## Notable differences for the upgrades

I'll write down what I remember annoying for this challenge.

- kube-apiserver.service should have `--runtime-config=api/all=true` instead of `--runtime-config=api/all` for its boot option
- kube-controller-manager.service should have `--master=http://localhost:8080` in adittion.
