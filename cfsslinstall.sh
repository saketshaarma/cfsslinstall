#!/bin/bash
#Run this script with bash -x ./script.sh not with sh -x ./script.sh
set -e

RELEASE=unknown

Os_check(){
    if [ -f /etc/redhat-release ]; then
        version=$( cat /etc/redhat-release | grep -oP "[0-9]+" | head -1 )
        RELEASE=Centos
    elif [ -f /etc/lsb-release ]; then
        version=$( cat /etc/lsb-release | grep -oP "[0-9]+" | head -1 )
        RELEASE=Ubuntu
    elif [ -f /System/Library/CoreServices/SystemVersion.plist ]; then
        RELEASE=Mac
    fi
}

cfssl_install_linux(){
    VERSION=$(curl --silent "https://api.github.com/repos/cloudflare/cfssl/releases/latest" | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')
    VNUMBER=${VERSION#"v"}
    wget https://github.com/cloudflare/cfssl/releases/download/${VERSION}/cfssl_${VNUMBER}_linux_amd64 -O cfssl
    chmod +x cfssl
    sudo mv cfssl /usr/local/bin
}

cfssl_install_mac(){
    VERSION=$(curl --silent "https://api.github.com/repos/cloudflare/cfssl/releases/latest" | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')
    VNUMBER=${VERSION#"v"}
    wget https://github.com/cloudflare/cfssl/releases/download/${VERSION}/cfssl_${VNUMBER}_darwin_amd64 -O cfssl
    chmod +x cfssl
    sudo mv cfssl /usr/local/bin
}

verify_version(){
    cfssl version
    cfssljson -version
}

cfssljson_install_linux(){
    VERSION=$(curl --silent "https://api.github.com/repos/cloudflare/cfssl/releases/latest" | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')
    VNUMBER=${VERSION#"v"}
    wget https://github.com/cloudflare/cfssl/releases/download/${VERSION}/cfssljson_${VNUMBER}_linux_amd64 -O cfssljson
    chmod +x cfssljson
    sudo mv cfssljson /usr/local/bin
}

cfssljson_install_mac(){
    VERSION=$(curl --silent "https://api.github.com/repos/cloudflare/cfssl/releases/latest" | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')
    VNUMBER=${VERSION#"v"}
    wget https://github.com/cloudflare/cfssl/releases/download/${VERSION}/cfssljson_${VNUMBER}_darwin_amd64 -O cfssljson
    chmod +x cfssljson
    sudo mv cfssljson /usr/local/bin
}
Os_check
if [ "$RELEASE" == "Ubuntu" ] || [ "$RELEASE" == "Centos" ]; then
    cfssl_install_linux
    cfssljson_install_linux
else
    cfssl_install_mac
    cfssljson_install_mac
fi

verify_version
