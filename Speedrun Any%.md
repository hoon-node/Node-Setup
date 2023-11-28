# Node-Setup (Wireguard or V2Ray)

Check [https://github.com/sentinel-official/docs/tree/master/guides/nodes/dVPN](https://docs.sentinel.co/node-setup) for lengthily guide

Prerequisites:
1. Update and Upgrade

    ```sudo apt update && sudo apt upgrade -y```

‎

2. Have cURL package installed

    ```sudo apt-get install --yes curl```

‎

3. Be root

    ```sudo -i```

‎

> [!NOTE]
> Tested with Ubuntu 22.04


‎

  
## 1 line auto-restart Node-Setup
    

‎

* You will be asked to choose a name for your node (moniker). The answer has to be more than 4 letters.
* You will be asked to choose a key name. You can also choose to recover existing wallet after the script is done scripting.
* Once the script is finished save your mnemonic, starting command and (node)wallet address (neither will be shown again).
* You can change the default min price once the installation has finished.

    
‎


1. Run `curl https://raw.githubusercontent.com/hoon-node/Node-Setup/main/Speedrun.sh | bash`

    This will 
    * Get the official Docker installation script
    * Install Docker
    * Add user to Docker group
    * Create */etc/docker/daemon.json* with configuration
    * Restart the Docker process
    * Install `iptables-persistent` package (No recommended when asked to save IP rules)
    * Enable NAT for the private Docker subnet on the host
    * Install Git package
    * Clone the GitHub repository
    * Change the working directory and checkout to the latest tag
    * Build the image
    * Install `openssl` package
    * Initialize the application configuration *${HOME}/.sentinelnode/config.toml*
    * Initialize the WireGuard configuration *${HOME}/.sentinelnode/wireguard.toml*
    * Initialize the WireGuard configuration *${HOME}/.sentinelnode/v2ray.toml*
    * Create a self-signed TLS certificate
    * Move the created TLS keys
    * Ask you for your moniker and add it in the config.toml
    * Check for your IP to add it to the remote_url in the config.toml
    * Look for your API port and add it to the remote_url in the config.toml
    * Look for your Wireguard port for the starting command
    * Look for your v2ray port for the starting command
    * Ask you for your keyname and create a wallet with it
    * Give you an output with your seedphrase and (node)wallet **!!SAVE IT!!**
    * Give you an output with your starting command
    
‎


‎

