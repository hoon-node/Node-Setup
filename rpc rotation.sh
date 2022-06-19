#!/bin/bash

run () {

name=$(docker ps --format "{{.Names}}")
#status=$(docker ps --format "{{.Status}}")
rpc_addresses=("https://rpc.sentinel.co:443" "https://rpc.sentinel1.badgerbite.xyz:443" "https://rpc.mathnodes.com:443")
i=0

while [ "$name" = "sentinel-dvpn-node" ]
do

name=$(docker ps --format "{{.Names}}")
status=$(docker ps --format "{{.Status}}")

if [[ $status == *"seconds"* ]]; then

count_of_elements=${#rpc_addresses[@]}
rest=$(($i%$count_of_elements))
add_temp=$(printf "${rpc_addresses[$rest]}")

add=\"${add_temp}\"
sed -i -e "s#\(rpc_address *= *\).*#\1$add#" ${HOME}/.sentinelnode/config.toml

i=$((i+1))

fi

sleep 55
done

}
run



#  echo "It's there!"
#  echo $status
#  echo "${rpc_addresses[$RANDOM%${#rpc_addresses[@]}]}"
#  i=0


#add=${$rpc_addresses[$rest]}"
