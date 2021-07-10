#!/bin/bash

Y = y
N = n


echo "Enter your Node Moniker:"
read moniker_name

echo "Enter the price you want to charge per GB in udvpn:"
read price

echo "What do you name your wallet:"
read wallet_name

echo "Do you want to recover an existing wallet? (Y/N)"
read answer

echo "Set your wallet password:"
read wallet_password


if [$answer = $y]
then echo "Enter your mnemonic:"
read mnemonic
docker run --rm \
    --interactive \
    --tty \
    --volume ${HOME}/.sentinelnode:/root/.sentinelnode \
    sentinel-dvpn-node process keys add $wallet_name --recover < $mnemonic
else
docker run --rm \
    --interactive \
    --tty \
    --volume ${HOME}/.sentinelnode:/root/.sentinelnode \
    sentinel-dvpn-node process keys add $wallet_name
    

fi



run () {
   
    echo -e "\e[32mEnable IPv6 support for Docker"
    echo -e "\e[39m"
    echo '{
    "ipv6": true,
    "fixed-cidr-v6": "2001:db8:1::/64"
}' | sudo tee -a /etc/docker/daemon.json

    echo ""
    echo -e "\e[32mRestart the Docker process"
    echo -e "\e[39m"
    sudo systemctl restart docker
    
    echo ""
    echo -e "\e[32mInstall iptables-persistent package"
    echo -e "\e[39m"
    sudo apt-get install --yes iptables-persistent
    
    echo ""
    echo -e "\e[32mEnable NAT for the private Docker subnet on the host" 
    echo -e "\e[39m"
    rule="POSTROUTING -s 2001:db8:1::/64 ! -o docker0 -j MASQUERADE" && \
sudo ip6tables -t nat -C ${rule} || \
sudo ip6tables -t nat -A ${rule} && \
sudo sh -c "ip6tables-save > /etc/iptables/rules.v6"
    
    echo ""
    echo -e "\e[32mInstall Git package" 
    echo -e "\e[39m"
    sudo apt-get install --yes git
    
    echo ""
    echo -e "\e[32mClone the GitHub repository"
    echo -e "\e[39m"
    git clone https://github.com/sentinel-official/dvpn-node.git \
    ${HOME}/dvpn-node/
    
    echo ""
    echo -e "\e[32mChange the working directory and checkout to the latest tag"
    echo -e "\e[39m"
    cd ${HOME}/dvpn-node/ && \
commit=$(git rev-list --tags --max-count=1) && \
git checkout $(git describe --tags ${commit})
    
    echo ""
    echo -e "\e[32mBuild the image"
    echo -e "\e[39m"
    docker build --file Dockerfile \
    --tag sentinel-dvpn-node \
    --force-rm \
    --no-cache \
    --compress .
    
    echo ""
    echo -e "\e[32mInstall openssl package"
    echo -e "\e[39m"
    sudo apt-get install --yes openssl
    
   
    echo ""
    echo -e "\e[32mInitialize the application configuration"
    echo -e "\e[39m"
    docker run --rm \
    --volume ${HOME}/.sentinelnode:/root/.sentinelnode \
    sentinel-dvpn-node process config init
   
   
    echo ""
    echo -e "\e[32mInitialize the wireguard configuration"
    echo -e "\e[39m"
    docker run --rm \
    --volume ${HOME}/.sentinelnode:/root/.sentinelnode \
    sentinel-dvpn-node process wireguard config init
    
    
    echo ""
    echo -e "\e[32mCreate a self-signed TLS certificate"
    echo -e "\e[39m"
    openssl req -new \
  -newkey ec \
  -pkeyopt ec_paramgen_curve:prime256v1 \
  -x509 \
  -sha256 \
  -days 365 \
  -nodes \
  -out ${HOME}/tls.crt \
  -keyout ${HOME}/tls.key
    
    
}

run
