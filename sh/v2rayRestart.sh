#!/bin/bash
sudo docker rm -f sentinel-dvpn-node && echo "Docker container removed" && \
rm ${HOME}/.sentinelnode/data.db && echo "File deleted" && \
sleep 2 && echo "Paused for 4 seconds" && \
sudo docker run -d \
    --name sentinel-dvpn-node \
    --restart unless-stopped \
    --volume /root/.sentinelnode:/root/.sentinelnode \
    --publish $(grep -oP 'listen_on = \"0.0.0.0:\K\d+' ~/.sentinelnode/config.toml):$(grep -oP 'listen_on = \"0.0.0.0:\K\d+' ~/.sentinelnode/config.toml)/tcp  \
    --publish $(grep -oP 'listen_port = \K\d+' ~/.sentinelnode/v2ray.toml):$(grep -oP 'listen_port = \K\d+' ~/.sentinelnode/v2ray.toml)/tcp \
    sentinel-dvpn-node process start
