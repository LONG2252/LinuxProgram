#永久关闭防火墙
systemctl stop firewalld.service
systemctl disable firewalld.service 

#永久关闭selinux
#getenforce
setenforce 0
getenforce  #查看selinux状态
cp /etc/selinux/config etc/selinux/config.bak
sed -i 's/SELINUX=enforcing/SELINUX=disable/g' /etc/selinux/config
#sed -i 's/SELINUX=disable/SELINUX=enforcing/g' /etc/selinux/config

#关闭swap
swapoff -a
free
cp /etc/fstab /etc/fstab.bak
sed -i '11s/^/#/g' /etc/fstab

#添加host
cp /etc/hosts /etc/hosts.bak

sed -i '$a 192.168.2.210 master\n192.168.2.211 node1\n192.168.2.212 node2\n192.168.2.213 node3\n192.168.2.214 node4\n192.168.2.215 node5\n192.168.2.216 node6\n192.168.2.217 node7\n192.168.2.218 node8' /etc/hosts

cat /etc/hosts
#将桥接的IPV4流量传递到iptables 的链
cat > /etc/sysctl.d/k8s.conf << EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

sysctl --system


#安装wget
yum -y install wget

#更换阿里源
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
wget -O /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo
yum makecache





#安装docker
wget https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo -O/etc/yum.repos.d/docker-ce.repo
yum -y install docker-ce-18.06.1.ce-3.el7
systemctl enable docker
mkdir /etc/docker/daemon.json
echo '{
 "exec-opts":["native.cgroupdriver=systemd"]
}' >/etc/docker/daemon.json

systemctl start docker
docker --version

#添加阿里云YUM软件源
cat > /etc/yum.repos.d/kubernetes.repo << EOF
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg
https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF


#安装kubeadm，kubelet和kubectl
yum makecache fast
yum install -y kubelet kubeadm kubectl
yum install -y kubeadm-1.18.2-0.x86_64 --nogpgcheck
systemctl enable kubelet


kubeadm join 192.168.2.210:6443 --token pryjxk.ozs60ptyb2e6x33e \
    --discovery-token-ca-cert-hash sha256:2e157ef362a75c386a56104de8a9dd2c9d4af054da122237bfd7e81c49f1575a












