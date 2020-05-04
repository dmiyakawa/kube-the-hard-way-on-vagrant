# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"
  # vagrant deploy timeout(sec)
  config.vm.boot_timeout = 600

  # VirtualMachine common settings
  config.vm.provider "virtualbox" do |vb|
    vb.cpus = "1"
    vb.memory = "1024"
    vb.customize [ "modifyvm", :id, "--uartmode1", "disconnected" ]
  end

  # LB/workspace machine
  config.vm.define "lb-0" do |c|
    c.vm.hostname = "lb-0"
    c.vm.network "private_network", ip: "10.240.0.40"

    # install and setting haproxy
    c.vm.provision "shell", inline: <<-SHELL
apt-get update
apt-get install -y haproxy

grep -q -F 'net.ipv4.ip_nonlocal_bind=1' /etc/sysctl.conf || echo 'net.ipv4.ip_nonlocal_bind=1' >> /etc/sysctl.conf

cat >/etc/haproxy/haproxy.cfg <<EOF
global
  log /dev/log  local0
  log /dev/log  local1 notice
  chroot /var/lib/haproxy
  stats socket /run/haproxy/admin.sock mode 660 level admin
  stats timeout 30s
  user haproxy
  group haproxy
  daemon
  ca-base /etc/ssl/certs
  crt-base /etc/ssl/private
  ssl-default-bind-ciphers ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:ECDH+3DES:DH+3DES:RSA+AESGCM:RSA+AES:RSA+3DES:!aNULL:!MD5:!DSS
  ssl-default-bind-options no-sslv3
defaults
  log  global
  mode  tcp
  option  tcplog
  option  dontlognull
  timeout connect 5000
  timeout client  50000
  timeout server  50000
  errorfile 400 /etc/haproxy/errors/400.http
  errorfile 403 /etc/haproxy/errors/403.http
  errorfile 408 /etc/haproxy/errors/408.http
  errorfile 500 /etc/haproxy/errors/500.http
  errorfile 502 /etc/haproxy/errors/502.http
  errorfile 503 /etc/haproxy/errors/503.http
  errorfile 504 /etc/haproxy/errors/504.http
frontend k8s
  bind 10.240.0.40:6443
  default_backend k8s_backend
backend k8s_backend
  balance roundrobin
  mode tcp
  server controller-0 10.240.0.10:6443 check inter 1000
  server controller-1 10.240.0.11:6443 check inter 1000
  server controller-2 10.240.0.12:6443 check inter 1000
EOF

systemctl restart haproxy
    SHELL
  end

  # k8s controller servers
  (0..2).each do |n|
    config.vm.define "controller-#{n}" do |c|
      c.vm.hostname = "controller-#{n}"
      c.vm.network "private_network", ip: "10.240.0.1#{n}"

      # setting hosts file
      c.vm.provision "shell", inline: <<-SHELL
cat >/etc/hosts <<EOF
127.0.0.1       localhost

# KTHW Vagrant machines
10.240.0.10     controller-0
10.240.0.11     controller-1
10.240.0.12     controller-2
10.240.0.20     worker-0
10.240.0.21     worker-1
10.240.0.22     worker-2
EOF
      SHELL
    end
  end

  # k8s worker servers
  (0..2).each do |n|
    config.vm.define "worker-#{n}" do |c|
      c.vm.hostname = "worker-#{n}"
      c.vm.network "private_network", ip: "10.240.0.2#{n}"

      # setting hosts file and routings
      c.vm.provision "shell", inline: <<-SHELL
cat >/etc/hosts <<EOF
127.0.0.1       localhost

# KTHW Vagrant machines
10.240.0.10     controller-0
10.240.0.11     controller-1
10.240.0.12     controller-2
10.240.0.20     worker-0
10.240.0.21     worker-1
10.240.0.22     worker-2
EOF
case "$(hostname)" in
  worker-0)
    route add -net 10.200.1.0/24 gw 10.240.0.21
    route add -net 10.200.2.0/24 gw 10.240.0.22
    ;;
  worker-1)
    route add -net 10.200.0.0/24 gw 10.240.0.20
    route add -net 10.200.2.0/24 gw 10.240.0.22
    ;;
  worker-2)
    route add -net 10.200.0.0/24 gw 10.240.0.20
    route add -net 10.200.1.0/24 gw 10.240.0.21
    ;;
  *)
    route add -net 10.200.0.0/24 gw 10.240.0.20
    route add -net 10.200.1.0/24 gw 10.240.0.21
    route add -net 10.200.2.0/24 gw 10.240.0.22
    ;;
esac
      SHELL
    end
  end
end
