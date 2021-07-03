#!/bin/bash


run () {
        
    echo "Update the list of available software packages"
    echo ""
    sudo apt-get update

    echo ""
    echo "Install cURL package"
    echo ""
    sudo apt-get install --yes curl
    
    echo ""
    echo "Get the official Docker installation script"
    echo ""
    curl -fsSL get.docker.com -o ${HOME}/get-docker.sh
    
    echo ""
    echo "Install Docker" 
    echo ""
    sudo sh ${HOME}/get-docker.sh
    
    echo ""
    echo "Add user to Docker group" 
    echo ""
    sudo usermod -aG docker $(whoami)
    
    echo ""
    echo "Reboot the machine"
    sudo reboot now
    
}

run
