#!/bin/bash

# Read the node type from the config file
node_type=$(cat /root/.sentinelnode/config.toml | grep type | awk -F'"' '{print $2}')

if [ "$node_type" = "v2ray" ]; then
  echo "Restarting v2ray node..."
  sudo docker rm -f sentinel-dvpn-node && echo "Docker container removed" && \
  rm ${HOME}/.sentinelnode/data.db && echo "File deleted" && \
  sleep 2 && echo "Paused for 4 seconds" && \
  sudo docker run -d \
    --name sentinel-dvpn-node \
    --restart unless-stopped \
    --volume /root/.sentinelnode:/root/.sentinelnode \
    --publish $(grep -oP 'listen_on = \"0.0.0.0:\K\d+' ~/.sentinelnode/config.toml):$(grep -oP 'listen_on = \"0.0.0.0:\K\d+' ~/.sentinelnode/config.toml)/tcp \
    --publish $(grep -oP 'listen_port = \K\d+' ~/.sentinelnode/v2ray.toml):$(grep -oP 'listen_port = \K\d+' ~/.sentinelnode/v2ray.toml)/tcp \
    sentinel-dvpn-node process start
elif [ "$node_type" = "wireguard" ]; then
  echo "Restarting wireguard node..."
  sudo docker rm -f sentinel-dvpn-node && echo "Docker container removed" && \
  rm ${HOME}/.sentinelnode/data.db && echo "File deleted" && \
  sleep 2 && echo "Paused for 4 seconds" && \
  sudo docker run -d --name sentinel-dvpn-node --restart unless-stopped --volume /root/.sentinelnode:/root/.sentinelnode --volume /lib/modules:/lib/modules --cap-drop ALL --cap-add NET_ADMIN --cap-add NET_BIND_SERVICE --cap-add NET_RAW --cap-add SYS_MODULE --sysctl net.ipv4.ip_forward=1 --sysctl net.ipv6.conf.all.disable_ipv6=0 --sysctl net.ipv6.conf.all.forwarding=1 --sysctl net.ipv6.conf.default.forwarding=1 --publish $(grep -oP 'listen_on = \"0.0.0.0:\K\d+' ~/.sentinelnode/config.toml):$(grep -oP 'listen_on = \"0.0.0.0:\K\d+' ~/.sentinelnode/config.toml)/tcp --publish $(grep -oP 'listen_port = \K\d+' ~/.sentinelnode/wireguard.toml):$(grep -oP 'listen_port = \K\d+' ~/.sentinelnode/wireguard.toml)/udp sentinel-dvpn-node process start
else
  echo "Unknown node type: $node_type"
  exit 1
fi

echo "Node restart completed successfully."
