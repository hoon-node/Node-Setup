# Node-Setup (Wireguard)

Check https://github.com/sentinel-official/docs/tree/master/guides/nodes/dVPN for lengthily guide

Prerequisites:
1. Have cURL package installed

    ```sudo apt-get install --yes curl```

‎

2. Be root

    ```sudo -i```
    
‎

  
## Method 1 - One line auto-restart Node-Setup
    

‎

* You will be asked to choose a name for your node (moniker). The answer has to be more than 4 letters.
* You will be asked to set a gigabyte price for your node. Where 1 DVPN = 1000000udpvn. Your answer must include udvpn after the numbers (e.g. 500000udvpn).
* You will be asked to set a hourly price for your node. Where 1 DVPN = 1000000udpvn. Your answer must include udvpn after the numbers (e.g. 500000udvpn).
* You will be asked to choose a key name. You can also choose to recover existing wallets with this script after the script is done scripting.
* Once the script is finnished save your mnemonic, starting command and (node)wallet address (neither will be shown again).

    
‎


1. Run `curl https://raw.githubusercontent.com/hoon-node/Node-Setup/main/Actual%20speedrun%20tho.sh | bash`

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
    * Create a self-signed TLS certificate
    * Move the created TLS keys
    * Ask you for your moniker and add it in the config.toml
    * Ask you for the price you want to charge and add it in the config.toml
    * Check for your IP to add it to the remote_url in the config.toml
    * Look for your API port and add it to the remote_url in the config.toml
    * Look for your Wireguard port
    * Ask you for your keyname and create a wallet with it
    * Give you an output with your seedphrase and (node)wallet **!!SAVE IT!!**
    * Give you an output with your starting command
    
‎


‎

