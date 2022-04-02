
# Update instructions



    
‎

1. Stop your node with

    * `sudo docker ps` to get your node ID
    * `sudo docker stop <ID>` to stop the node
    * `sudo docker rm - f <ID>` to remove the container

    
‎


2. Run `curl https://raw.githubusercontent.com/hoon-node/Node-Setup/main/update.sh | bash`

    This will 
    * Remove old Version
    * Clone & checkout Git
    * Re-Build docker
    
‎

3. Start your node with the usal command


    
‎
