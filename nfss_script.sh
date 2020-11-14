#!/bin/bash
cat <<EOF >> /etc/hosts
192.168.50.12 kerberos.example.com
192.168.50.10 nfss.example.com
192.168.50.11 nfsc.example.com
EOF
yum install krb5-workstation -y 
sed -i '2,$s/#//g' /etc/krb5.conf
AdminPassword="1234"
HOST="nfss.example.com"
{ 
echo "$AdminPassword"; 
echo "addprinc -randkey host/$HOST"; 
echo "ktadd host/$HOST"; 
echo "quit"; }| kadmin
{ 
echo "$AdminPassword"; 
echo "addprinc -randkey nfs/$HOST"; 
echo "ktadd nfs/$HOST"; 
echo "quit"; }| kadmin
mkdir -p /srv/nfs/upload
mkdir /srv/nfsudp
chmod a+wt /srv/nfs/upload
cat << EOF >> /etc/exports 
/srv/nfs/ nfsc.example.com(rw,async,root_squash,sec=krb5)
/srv/nfsudp/ nfsc.example.com(ro,async,root_squash)
EOF
systemctl start nfs-server
systemctl enable nfs-server
exportfs -rav
service rpc-gssd restart
systemctl enable firewalld
systemctl start firewalld
firewall-cmd --new-zone=nfs_access --permanent
firewall-cmd --zone=nfs_access --add-source=192.168.50.11/32 --permanent
firewall-cmd --permanent --zone=nfs_access --add-service=nfs
firewall-cmd --permanent --zone=nfs_access --add-service=mountd
firewall-cmd --permanent --zone=nfs_access --add-service=rpc-bind
firewall-cmd --permanent --zone=nfs_access --add-port=2049/udp
systemctl reload firewalld

