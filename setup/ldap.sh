#!/usr/bin/bash
# https://www.server-world.info/en/note?os=CentOS_7&p=openldap

db_config="/var/lib/ldap/DB_CONFIG"
if [ ! -e $db_config ]; then
    sudo cp /usr/share/openldap-servers/DB_CONFIG.example $db_config
    sudo chown ldap. /var/lib/ldap/DB_CONFIG 
fi
firewall-cmd --add-service=ldap --permanent > /dev/null
firewall-cmd --reload > /dev/null
sudo systemctl start slapd 
sudo systemctl enable slapd 

# get host and tld from hostname
hostname=$(hostname)
if [[ $hostname =~ ^([a-z]+)\.([a-z]+)$ ]]; then
    host=${BASH_REMATCH[1]}
    tld=${BASH_REMATCH[2]}
else
    echo "Hostname not set or invalid: $hostname"
    exit
fi

# cert
read -p "Do you want to create a new cert (y/[n])? " -n 1 -r
echo 
cert_path="/etc/pki/tls/certs/$host${tld}_ldap_cert.pem"
priv_path="/etc/pki/tls/certs/$host${tld}_ldap_priv.pem"
if [[ $REPLY =~ ^[Yy]$ ]]; then
    sudo openssl req -new -x509 -nodes -out $cert_path -keyout $priv_path -days 365
    sudo chown ldap:ldap $cert_path
    sudo chown ldap:ldap $priv_path
    sudo chmod 600 $priv_path
    echo "new cert at $cert_path"
    echo "new private key at $priv_path"
fi
echo

# root password
read -p "Do you want to create a new root pw (y/[n])? " -n 1 -r
echo 
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Enter root ldap password"
    ssha=$(slappasswd)
    echo="dn: olcDatabase={0}config,cn=config
    changetype: modify
    replace: olcRootPW
    olcRootPW: $ssha" | \
    sudo ldapadd -Y EXTERNAL -H ldapi:///
fi
echo

#schemas
read -p "Do you want to copy the default schemas (y/[n])? " -n 1 -r
echo 
if [[ $REPLY =~ ^[Yy]$ ]]; then
    if ! -e /etc/openldap/schema/mozillaAbPersonAlpha.ldif; then
        dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
        sudo cp $dir/mozillaAbPersonAlpha.ldif /etc/openldap/schema
    fi
    schemas="cosine nis core inetorgperson mozillaAbPersonAlpha"
    for schema in $schemas; do
        echo "enabling $schema schema" 
        sudo ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/$schema.ldif
    done
fi
echo

read -p "Do you want to create the directory manager's pw (y/[n])? " -n 1 -r
echo 
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Enter directory manager's password"
    ssha=$(slappasswd)

    echo "dn: olcDatabase={1}monitor,cn=config
    changetype: modify
    replace: olcAccess
    olcAccess: {0}to * by dn.base="gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth"
    read by dn.base="cn=Manager,dc=$host,dc=$tld" read by * none

    dn: olcDatabase={2}hdb,cn=config
    changetype: modify
    replace: olcSuffix
    olcSuffix: dc=$host,dc=$tld

    dn: olcDatabase={2}hdb,cn=config
    changetype: modify
    replace: olcRootDN
    olcRootDN: cn=Manager,dc=$host,dc=$tld

    dn: olcDatabase={2}hdb,cn=config
    changetype: modify
    replace: olcRootPW
    olcRootPW: $ssha

    dn: olcDatabase={2}hdb,cn=config
    changetype: modify
    replace: olcAccess
    olcAccess: {0}to attrs=userPassword,shadowLastChange by
        dn="cn=Manager,dc=$host,dc=$tld" write by anonymous auth by self write by * none
    olcAccess: {1}to dn.base="" by * read
    olcAccess: {2}to * by dn="cn=Manager,dc=$host,dc=$tld" write by * read" | \
    sudo ldapadd -Y EXTERNAL -H ldapi:///
fi
echo


read -p "Do you want to create the basic OUs (y/[n])? " -n 1 -r
echo 
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "dn: dc=$host,dc=$tld
    objectClass: top
    objectClass: dcObject
    objectclass: organization
    o: $hostname
    dc: $host

    dn: cn=Manager,dc=$host,dc=$tld
    objectClass: organizationalRole
    cn: Manager
    description: Directory Manager

    dn: ou=People,dc=$host,dc=$tld
    objectClass: organizationalUnit
    ou: People

    dn: ou=Contacts,dc=$host,dc=$tld
    objectClass: organizationalUnit
    ou: Mail

    dn: ou=Group,dc=$host,dc=$tld
    objectClass: organizationalUnit
    ou: Group" | \
    ldapadd -x -D cn=Manager,dc=$host,dc=$tld -W
fi
echo
sudo systemctl restart slapd 
echo "finishing installing openldap"
