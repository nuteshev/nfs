#!/bin/bash
cat <<EOF >> /etc/hosts
192.168.50.12 kerberos.example.com
192.168.50.10 nfss.example.com
192.168.50.11 nfsc.example.com
EOF
yum install krb5-server -y
sed -i '2,$s/#//g' /etc/krb5.conf
sed -i  's/#//g' /var/kerberos/krb5kdc/kdc.conf
Password="123456"
{ echo "$Password"; echo "$Password"; }| kdb5_util create -s -r EXAMPLE.COM

systemctl enable krb5kdc
systemctl enable kadmin
systemctl start krb5kdc
systemctl start kadmin
AdminPassword="1234"
{ 
echo "addprinc root/admin"; 
echo "$AdminPassword"; 
echo "$AdminPassword"; 
echo "addprinc -randkey host/kerberos.example.com"; 
echo "ktadd host/kerberos.example.com"; 
echo "quit"; }| kadmin.local