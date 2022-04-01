
# Update instructions



    
‎

1. Stop your node

    
‎


2. Run `curl https://raw.githubusercontent.com/hoon-node/Node-Setup/main/update.sh | bash`

    This will 
    * Remove old Version
    * Clone & checkout Git
    * Re-Build docker
    
‎

3. Start your node with the usal command

```
sudo docker run -d \
    --name sentinel-dvpn-node \
    --restart unless-stopped \
    --volume ${HOME}/.sentinelnode:/root/.sentinelnode \
    --volume /lib/modules:/lib/modules \
    --cap-drop ALL \
    --cap-add NET_ADMIN \
    --cap-add NET_BIND_SERVICE \
    --cap-add NET_RAW \
    --cap-add SYS_MODULE \
    --sysctl net.ipv4.ip_forward=1 \
    --sysctl net.ipv6.conf.all.disable_ipv6=0 \
    --sysctl net.ipv6.conf.all.forwarding=1 \
    --sysctl net.ipv6.conf.default.forwarding=1 \
    --publish API:API/tcp \
    --publish WIREGUARD:WIREGUARD/udp \
    sentinel-dvpn-node process start
```

    
‎
