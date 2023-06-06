#!/bin/bash

set -o allexport
source .env
set +o allexport

create_certificate() {
    cat << EOF > config_$CERT_NAME.cnf
[req]
default_bits = $DEFAULT_BITS
prompt = $PROMPT
default_md = $DEFAULT_MD
x509_extensions = $X509_EXTENSIONS
distinguished_name = dn

[dn]
C=$CONTRY_CODE
ST=$STATE
L=$LOCALITY
O=$ORGANIZATION
OU=$ORGANIZATIONAL_UNIT
CN=$COMMON_NAME

[$X509_EXTENSIONS]
subjectAltName = @alt_names

[alt_names]
$SUB_ALT_NAMES

EOF

    echo -e "\033[33;3mCreating private .key file...\033[0m"
    openssl req -new -x509 -newkey rsa:2048 -sha256 -nodes -keyout private_$CERT_NAME.key -days $EXPIRE_DATE -out crt_$CERT_NAME.crt -config config_$CERT_NAME.cnf
    
    echo -e "\033[33;3mCreating .pem file...\033[0m"
    cat crt_$CERT_NAME.crt private_$CERT_NAME.key > pem_$CERT_NAME.pem

    echo -e "\033[33;3mCreating .p12 and .pfx file...\033[0m"
    openssl pkcs12 -export -out p12_$CERT_NAME.p12 -inkey private_$CERT_NAME.key -in crt_$CERT_NAME.crt -passin pass:$KEYSTORE_PASSWORD -passout pass:$KEYSTORE_PASSWORD -name $CERT_NAME
    openssl pkcs12 -export -out pfx_$CERT_NAME.pfx -inkey private_$CERT_NAME.key -in crt_$CERT_NAME.crt -passin pass:$KEYSTORE_PASSWORD -passout pass:$KEYSTORE_PASSWORD -name $CERT_NAME
    
    echo -e "\033[33;3mCreating .jks file...\033[0m"
    keytool -importkeystore -deststorepass $KEYSTORE_PASSWORD -destkeypass $KEYSTORE_PASSWORD -destkeystore jks_$CERT_NAME.jks -srckeystore p12_$CERT_NAME.p12 -srcstoretype PKCS12 -srcstorepass $KEYSTORE_PASSWORD -alias $CERT_NAME

    echo -e "\033[32;5mMaking certificates has been completed...\033[0m"
}

# Check if Java is installed
if type -p java; then
    echo -e "\033[32;5mJava is already installed...\033[0m"
    create_certificate
else
    echo -e "\033[33;4mJava is not yet installed on this system...\033[0m"
    read -p "Do you want to install Java? (y/n): " choice
    if [ "$choice" == "y" ] || [ "$choice" == "Y" ]; then
        # Install OpenJDK 11
        sudo apt update
        sudo apt install -y openjdk-11-jdk
        # Check installation success
        if [ -x "$(command -v java)" ]; then
            echo -e "\033[32;5mOpenJDK 11 was successfully installed...\033[0m"
            create_certificate
        else
            echo -e "\033[31;5mAn error occurred while installing OpenJDK 11...\033[0m"
        fi
    else
        echo -e "\033[33;4mJava installation is canceled...\033[0m"
    fi
fi
