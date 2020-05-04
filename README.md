# Kubernetes the Hard Way on Vagrant, 2020-05

The misc files when I tried "Kubernetes the Hard Way" with Vagrant + VirtualBox.

This is based on the nice tutorial with the similar theme in Japanese: https://qiita.com/t_ume/items/5d24b377e08669155639

This repository is just for my record, so I don't have any plan to actively maintain this.
No VM images are not associated. No detailed instructions are available at this moment.

One possibly better thing compare to other similar great tutorials might be,
this repo contains config files that actually worked with Kubernetes v1.18.2, latest as of writing (2020-05).
The original version uses v1.15.3, so a few modifications are needed to migrate to the latest, which is bit of a headache.
Please feel free to look at each file when you want to compare your work with someone else who was successful.

More specifically, I confirmed this project with the following software versions:

- Ubuntu 18.04.4 LTS (Both host and all VirtualBox VMs)
- VirtuarBox v6.1.6
- Vagrant 2.2.7
- Kubernetes: v1.18.2
- Containerd: 1.3.4
- runc: v1.0.0-rc10
- etcd: v3.4.7

I tried this tutorial with 32GB memory machine + i7-7700 which has sufficient power to run 7 VirtualBox VMs in total.
I encountered no problem along with the physical environment (though VT-X needed to be turned on to run VirtualBox first)


## How to get started

For the initial setup, run setup.sh, which will download `cfssl`, `cfssljson`, and `kubectl`

```
$ ./setup.sh
```

Then, assuming you're using zsh,

```
$ source ./activate.zsh
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
