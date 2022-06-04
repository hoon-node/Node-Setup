#!/bin/bash


run () {
        
    echo -e "\e[32mStop Node Docker"
    echo -e "\e[39m"
    sudo docker stop sentinel-dvpn-node
            
    echo -e "\e[32mRemove Node Docker"
    echo -e "\e[39m"
    sudo docker rm -f sentinel-dvpn-node     
        
    
    echo -e "\e[32mRemove old Version"
    echo -e "\e[39m"
    rm -r ${HOME}/dvpn-node/

    echo ""
    echo -e "\e[32mClone Git"
    echo -e "\e[39m"
    git clone https://github.com/sentinel-official/dvpn-node.git
    
    echo ""
    echo -e "\e[32mGot to new dir"
    echo -e "\e[39m"
    cd ${HOME}/dvpn-node/
    
    echo ""
    echo -e "\e[32mFetch" 
    echo -e "\e[39m"
    git fetch
    
    echo ""
    echo -e "\e[32mcheckout" 
    echo -e "\e[39m"
    git checkout v0.3.2
    
    echo ""
    echo -e "\e[32mBuild docker"
    echo -e "\e[39m"
    docker build --file Dockerfile \
    --tag sentinel-dvpn-node \
    --force-rm \
    --no-cache \
    --compress .
    
}

run
