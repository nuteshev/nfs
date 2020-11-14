#!/bin/bash
cat <<EOF >> /etc/hosts
192.168.50.12 kerberos.example.com
192.168.50.10 nfss.example.com
192.168.50.11 nfsc.example.com
EOF
yum install krb5-workstation nfs-utils -y 
sed -i '2,$s/#//g' /etc/krb5.conf
AdminPassword="1234"
HOST="nfsc.example.com"
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
mkdir /mnt/nfs
mkdir /mnt/nfsudp
echo "nfss.example.com:/srv/nfs /mnt/nfs nfs nfsvers=3,sec=krb5 0 0" >> /etc/fstab
echo "nfss.example.com:/srv/nfsudp /mnt/nfsudp nfs nfsvers=3,udp 0 0" >> /etc/fstab
systemctl restart nfs-secure
mount -a