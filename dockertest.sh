#!/bin/bash


run () {

    echo -e "\e[32mUpdate the list of available software packages"
    echo -e "\e[39m"
    sudo apt-get update

    echo ""
    echo -e "\e[32mInstall cURL package"
    echo -e "\e[39m"
    sudo apt-get install --yes curl
    
    echo ""
    echo -e "\e[32mGet the official Docker installation script"
    echo -e "\e[39m"
    curl -fsSL get.docker.com -o ${HOME}/get-docker.sh
    
    echo ""
    echo -e "\e[32mInstall Docker" 
    echo -e "\e[39m"
    sudo sh ${HOME}/get-docker.sh
    
    echo ""
    echo -e "\e[32mAdd user to Docker group" 
    echo -e "\e[39m"
    sudo usermod -aG docker $(whoami)


    echo ""
    echo -e "\e[32mAdding...."
    echo -e "\e[39m"
    newgrp docker
    
    
    
    us=$(awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd)
    uss=( $us )
    numb=$(echo -n "$us" | wc -w)
    var=0
    
    while (( $var < $numb))
    do
        
    echo ""
    echo -e "\e[32mAdd user to Docker group" 
    echo -e "\e[39m"
    sudo usermod -aG docker ${uss[$var]}


    echo ""
    echo -e "\e[32mAdding...."
    echo -e "\e[39m"
    newgrp docker ${uss[$var]}
    
    var=$((var+1))
    done
 

}
run
