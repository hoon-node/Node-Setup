#!/bin/bash


run () {

#''''''''''''get ports && add remote url''''''''''''''''''''''''''''

wireguard_listen_port=$(awk -F= '/^.*listen_port/{gsub(/ /,"",$2);print $2}' ${HOME}/.sentinelnode/wireguard.toml)

api_listen_port=$(awk -F= '/^.*listen_on/{gsub(/ /,"",$2);print $2}' ${HOME}/.sentinelnode/config.toml)

api=${api_listen_port: 9}
api_listen_port=${api%?}

ip=`wget -q -O - checkip.dyndns.org|sed -e 's/.*Current IP Address: //' -e 's/<.*$//'`
http=https://
remote_url_temp="${http}${ip}:${api_listen_port}"
remote_url=\"${remote_url_temp}\"


sed -i -e "s%\(remote_url *= *\).*%\1$remote_url%" ${HOME}/.sentinelnode/config.toml



#''''''''''''ask for moniker && key name && price && test''''''''''''''''''''''''''''

echo ""
echo "\e[32mEnter node Moniker (the name your node is shown as):\e[m" 
read moniker_temp  </dev/tty


echo "\e[32mEnter the price you want to charge in ___udvpn (1dvpn=1000000udvpn):\e[m" 
read price_temp  </dev/tty


echo "\e[32mEnter your key name:\e[m" 
read key_temp  </dev/tty



moniker=\"${moniker_temp}\"

price=\"${price_temp}\"

key=\"${key_temp}\"

backend_temp=test
backend=\"${backend_temp}\"

sed -i -e "s/\(moniker *= *\).*/\1$moniker/" ${HOME}/.sentinelnode/config.toml

sed -i -e "s/\(price *= *\).*/\1$price/" ${HOME}/.sentinelnode/config.toml

sed -i -e "s/\(from *= *\).*/\1$key/" ${HOME}/.sentinelnode/config.toml

sed -i -e "s/\(backend *= *\).*/\1$backend/" ${HOME}/.sentinelnode/config.toml


#''''''''''''keys && seeds && farwell''''''''''''''''''''''''''''


key=${key_temp}

seed=$(docker run --rm \
    --tty \
    --volume ${HOME}/.sentinelnode:/root/.sentinelnode \
    sentinel-dvpn-node process keys add $key)


wallet=$(docker run --rm \
    --tty \
    --volume ${HOME}/.sentinelnode:/root/.sentinelnode \
    sentinel-dvpn-node process keys list private)
    

echo -e "\e[32mYour wallet and node addresses are:\e[m"
echo ""
echo $wallet
echo ""
echo ""
echo -e "\e[32mYour seedphrase is:\e[m"
echo ""
echo $seed

echo -e 
echo -e "\e[31m -----------SAVE BOTH------------ \e[m"
echo -e 

echo ""
echo -e "\e[32mTo start your node use the following command (maybe use tmux or screen):\e[m"
echo ""
echo "sudo docker run -d \ "
echo "    --name sentinel-dvpn-node \ "
echo "    --restart unless-stopped \ "
echo "    --volume ${HOME}/.sentinelnode:/root/.sentinelnode \ "
echo "    --volume /lib/modules:/lib/modules \ "
echo "    --cap-drop ALL \ "
echo "    --cap-add NET_ADMIN \ "
echo "    --cap-add NET_BIND_SERVICE \ "
echo "    --cap-add NET_RAW \ "
echo "    --cap-add SYS_MODULE \ "
echo "    --sysctl net.ipv4.ip_forward=1 \ "
echo "    --sysctl net.ipv6.conf.all.disable_ipv6=0 \ "
echo "    --sysctl net.ipv6.conf.all.forwarding=1 \ "
echo "    --sysctl net.ipv6.conf.default.forwarding=1 \ "
echo "    --publish ${api_listen_port}:${api_listen_port}/tcp \ "
echo "    --publish ${wireguard_listen_port}:${wireguard_listen_port}/udp \ "
echo "    sentinel-dvpn-node process start"



    
}

run
