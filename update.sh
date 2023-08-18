#!/bin/bash


run () {
        
    echo -e "\e[32mStop Node Docker"
    echo -e "\e[39m"
    sudo docker stop sentinel-dvpn-node
            
    echo -e "\e[32mRemove Node Docker"
    echo -e "\e[39m"
    sudo docker rm -f sentinel-dvpn-node 


    echo ""
    echo -e "\e[32mClone repository..."
    echo -e "\e[39m"

    git clone https://github.com/sentinel-official/dvpn-node.git
    cd ${HOME}/dvpn-node/

    echo ""
    echo -e "\e[32mSwitching to version v0.7.0..."
    echo -e "\e[39m"

    git fetch
    git checkout v0.7.0

    echo ""
    echo -e "\e[32mBuilding Docker image..."
    echo -e "\e[39m"

    docker build --file Dockerfile \
        --tag sentinel-dvpn-node \
        --force-rm \
        --no-cache \
        --compress .

    echo ""
    echo -e "\e[32mUpdating configuration file..."
    echo -e "\e[39m"

    # Update configuration file
    sed -i 's/price = /gigabyte_prices = /' ~/.sentinelnode/config.toml
    sed -i '/gigabyte_prices = /a hourly_prices = "4900000udvpn"' ~/.sentinelnode/config.toml


     echo ""
    echo -e "\e[32mCleaning up Docker builder cache..."
    echo -e "\e[39m"

    # Automatically confirm Docker builder cache pruning
    yes | docker builder prune
    

    echo ""
    echo -e "\e[32mUpdate completed successfully!"
    echo -e "\e[39m"


    
}

run
