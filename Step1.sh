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
    echo -e "\e[32mReboot the machine now"
    echo -e "\e[39m"
    
}

run
