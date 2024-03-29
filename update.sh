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
    echo -e "\e[32mSwitching to version v0.7.1..."
    echo -e "\e[39m"

    git fetch
    git checkout v0.7.1

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
    # sed -i 's/rpc_addresses = "https:\/\/rpc.sentinel.co:443"/rpc_addresses = "https:\/\/rpc.sentinel.quokkastake.io:443"/' ~/.sentinelnode/config.toml
    # sed -i 's/price = ""/gigabyte_prices = "5105000ibc\/31FEE1A2A9F9C01113F90BD0BBCCE8FD6BBB8585FAF109A2101827DD1D5B95B8,356000ibc\/A8C2D23A1E6F95DA4E48BA349667E322BD7A6C996D8A4AAE8BA72E190F3D1477,520000000ibc\/B1C0DDB14F25279A2026BC8794E12B259F8BDA546A3C5132CCAEE4431CE36783,5200000ibc\/ED07A3391A112B175915CD8FAF43A2DA8E4790EDE12566649D0C2F97716B8518,15000000udvpn"/' ~/.sentinelnode/config.toml
    # sed -i '/gigabyte_prices = /a hourly_prices = "4900000udvpn"' ~/.sentinelnode/config.toml
    # sed -i '/provider = /d' ~/.sentinelnode/config.toml


     echo ""
    echo -e "\e[32mCleaning up Docker builder cache..."
    echo -e "\e[39m"

    # Automatically confirm Docker builder cache pruning
    yes | docker builder prune
    

    echo ""
    echo -e "\e[32mUpdate completed successfully!"
    echo -e "\e[39m"

sleep 5

tmux send-keys -t 0:0 "sudo docker run -d --name sentinel-dvpn-node --restart unless-stopped --volume /root/.sentinelnode:/root/.sentinelnode --volume /lib/modules:/lib/modules --cap-drop ALL --cap-add NET_ADMIN --cap-add NET_BIND_SERVICE --cap-add NET_RAW --cap-add SYS_MODULE --sysctl net.ipv4.ip_forward=1 --sysctl net.ipv6.conf.all.disable_ipv6=0 --sysctl net.ipv6.conf.all.forwarding=1 --sysctl net.ipv6.conf.default.forwarding=1 --publish $(grep -oP 'listen_on = \"0.0.0.0:\K\d+' ~/.sentinelnode/config.toml):$(grep -oP 'listen_on = \"0.0.0.0:\K\d+' ~/.sentinelnode/config.toml)/tcp --publish $(grep -oP 'listen_port = \K\d+' ~/.sentinelnode/wireguard.toml):$(grep -oP 'listen_port = \K\d+' ~/.sentinelnode/wireguard.toml)/udp sentinel-dvpn-node process start" C-m ; tmux a -t 0

    
}

run
