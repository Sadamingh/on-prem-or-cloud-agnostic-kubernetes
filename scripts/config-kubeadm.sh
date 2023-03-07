# kubeadm configuration
echo '# kubeadm-config.yaml
kind: ClusterConfiguration
apiVersion: kubeadm.k8s.io/v1beta3
#kubernetesVersion: v1.21.0
networking:
  podSubnet: 10.211.0.0/16
---
kind: KubeletConfiguration
apiVersion: kubelet.config.k8s.io/v1beta1
cgroupDriver: cgroupfs' > kubeadm-config.yaml

# containerd config to work with Kubernetes >=1.26
echo "SystemdCgroup = true" > /etc/containerd/config.toml
systemctl restart containerd

# DigitalOcean with firewall (VxLAN with Flannel) - could be resolved in the future by allowing IP-in-IP in the firewall settings
echo "deploying kubernetes (with canal)..."
kubeadm init --config kubeadm-config.yaml # add --apiserver-advertise-address="ip" if you want to use a different IP address than the main server IP
export KUBECONFIG=/etc/kubernetes/admin.conf
curl https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/canal.yaml -O
kubectl apply -f canal.yaml
echo "HINT: "
echo "run the command: export KUBECONFIG=/etc/kubernetes/admin.conf if kubectl doesn't work"

