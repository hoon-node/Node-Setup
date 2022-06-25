# Node-Setup

Check https://github.com/sentinel-official/docs/tree/master/guides/nodes/dVPN for lengthily guide

Prerequisites:
1. Have cURL package installed

    ```sudo apt-get install --yes curl```

‎

2. Be root

    ```sudo -i```
    
‎

  
## Method 1 - One line auto-restart Node-Setup + RPC switch on RPC failure
    

‎


* You will be asked to set IP rules. No is the recommended answer.
* You will be asked to choose a name for your node (moniker). The answer has to be more than 4 letters.
* You will be asked to set a price for your node. Where 1 DVPN = 1000000udpvn. Your answer must include udvpn after the numbers (e.g. 500000udvpn).
* You will be asked to choose a key name. You can also choose to recover existing wallets with this script after the script is done scripting.
* Once the script is finnished save your mnemonic, starting command and (node)wallet address (neither will be shown again).
* You need to restart/start a new session before continuing.
* You need to be root user to import your wallet (if applicable).
* To start then ode you need to be root user.

    
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

2. Restart the machine

‎


3. RPC switcher (optional)

    Run `curl https://raw.githubusercontent.com/hoon-node/Node-Setup/main/rpcrotation.sh | bash &` in `tmux` for a background script that switches the RPC address in the config.toml when the node has to restart due to problems with its current RPC address.
    
 
‎   

* To stop the script either stop the docker image with `sudo docker rm -f sentinel-dvpn-node`.
* Or look up the PID with `jobs -l` and kill it with `kill <PID>`

‎


## Method 2 - Two line Node-Setup

‎
Soon

‎



## Method 3 - Long way

‎


1. Run `curl https://raw.githubusercontent.com/hoon-node/Node-Setup/main/Step1.sh | bash`

    This will 
    * Get the official Docker installation script
    * Install Docker
    * Add user to Docker group

‎


2. **RESTART** the machine
    
‎

4. Once restarted run `curl https://raw.githubusercontent.com/hoon-node/Node-Setup/main/Step2_3_4.sh | bash`
    
    This will 
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


‎

5. Create a self-signed TLS certificate

    ```
    openssl req -new \
      -newkey ec \
      -pkeyopt ec_paramgen_curve:prime256v1 \
      -x509 \
      -sha256 \
      -days 365 \
      -nodes \
      -out ${HOME}/tls.crt \
      -keyout ${HOME}/tls.key
    ```

‎

6. Open the config.toml `nano ${HOME}/.sentinelnode/config.toml`

   * Fill in your moniker (the name you give your node)
   * Fill in the keyname (wallet name) you will use for your wallet (`keyring` `from`)
   * Set `price` you will charge per GB (1dvpn = 1000000udvpn)
   * Look for API port and remember (number after : in `listen_on`)
   * Fill in your `remote_url` (format: `https://<PUBLIC_IP>:<API_PORT>`)

‎

7. Open the wireguard.toml `nano ${HOME}/.sentinelnode/wireguard.toml`
  
   * Look for wireguard port (`listen_port`) and remember

‎

8. Move created TLS keys

    ```
    mv ${HOME}/tls.crt ${HOME}/.sentinelnode/tls.crt
    mv ${HOME}/tls.key ${HOME}/.sentinelnode/tls.key
    ```

‎

9. Add/Recover an account key


    ```
    docker run --rm \
        --interactive \
        --tty \
        --volume ${HOME}/.sentinelnode:/root/.sentinelnode \
        sentinel-dvpn-node process keys add <KEY_NAME>
    ```

   * <KEY_NAME> is the value you set in the file config.toml for `from` under the section `keyring`
   * Pass flag `--recover` to recover the account with Mnemonic

‎

10. Run the node

    ```
    docker run --rm \
      --interactive \
      --tty \
      --volume ${HOME}/.sentinelnode:/root/.sentinelnode \
      --volume /lib/modules:/lib/modules \
      --cap-drop ALL \
      --cap-add NET_ADMIN \
      --cap-add NET_BIND_SERVICE \
      --cap-add NET_RAW \
      --cap-add SYS_MODULE \
      --sysctl net.ipv4.ip_forward=1 \
      --sysctl net.ipv6.conf.all.disable_ipv6=0 \
      --sysctl net.ipv6.conf.all.forwarding=1 \
      --sysctl net.ipv6.conf.default.forwarding=1 \
      --publish <API_PORT>:<API_PORT>/tcp \
      --publish <WIREGUARD_PORT>:<WIREGUARD_PORT>/udp \
      sentinel-dvpn-node process start
    ```
   * Replace <API_PORT>:<API_PORT> with your API port (E.g. 8585:8585)
   * Replace <WIREGUARD_PORT>:<WIREGUARD_PORT> with your wireguard port port (E.g. 60299:60299)
    


