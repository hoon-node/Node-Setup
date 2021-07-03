#!/bin/bash



run () {
   
    echo "Enable IPv6 support for Docker"
    echo ""
    echo '{
    "ipv6": true,
    "fixed-cidr-v6": "2001:db8:1::/64"
}' | sudo tee -a /etc/docker/daemon.json

    echo ""
    echo "Restart the Docker process"
    echo ""
    sudo systemctl restart docker
    
    echo ""
    echo "Install iptables-persistent package"
    echo ""
    sudo apt-get install --yes iptables-persistent
    
    echo ""
    echo "Enable NAT for the private Docker subnet on the host" 
    echo ""
    rule="POSTROUTING -s 2001:db8:1::/64 ! -o docker0 -j MASQUERADE" && \
sudo ip6tables -t nat -C ${rule} || \
sudo ip6tables -t nat -A ${rule} && \
sudo sh -c "ip6tables-save > /etc/iptables/rules.v6"
    
    echo ""
    echo "Install Git package" 
    echo ""
    sudo apt-get install --yes git
    
    echo ""
    echo "Clone the GitHub repository"
    echo ""
    git clone https://github.com/sentinel-official/dvpn-node.git \
    ${HOME}/dvpn-node/
    
    echo ""
    echo "Change the working directory and checkout to the latest tag"
    echo ""
    cd ${HOME}/dvpn-node/ && \
commit=$(git rev-list --tags --max-count=1) && \
git checkout $(git describe --tags ${commit})
    
    echo ""
    echo "Build the image"
    echo ""
    docker build --file Dockerfile \
    --tag sentinel-dvpn-node \
    --force-rm \
    --no-cache \
    --compress .
    
    echo ""
    echo "Install openssl package"
    echo ""
    sudo apt-get install --yes openssl
    
   
    echo ""
    echo "Initialize the application configuration"
    echo ""
    docker run --rm \
    --volume ${HOME}/.sentinelnode:/root/.sentinelnode \
    sentinel-dvpn-node process config init
   
   
    echo ""
    echo "Initialize the application configuration"
    echo ""
    docker run --rm \
    --volume ${HOME}/.sentinelnode:/root/.sentinelnode \
    sentinel-dvpn-node process wireguard config init
    
}

run
