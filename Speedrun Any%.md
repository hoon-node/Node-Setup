# Node-Setup

Check https://github.com/sentinel-official/docs/tree/master/guides/nodes/dVPN for lengthily guide

    
‎

1. Install cURL package

    ```sudo apt-get install --yes curl```
    
‎


2. Run `curl https://raw.githubusercontent.com/hoon-node/Node-Setup/main/Step1.sh | bash`

    This will 
    * Get the official Docker installation script
    * Install Docker
    * Add user to Docker group
    * **RESTART** the machine
    
‎

3. Once restarted run `curl https://raw.githubusercontent.com/hoon-node/Node-Setup/main/Step2_3_4.sh | bash`
    
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

8. Open the wireguard.toml `nano ${HOME}/.sentinelnode/wireguard.toml`
  
   * Look for wireguard port (`listen_port`) and remember

‎

10. Move created TLS keys

    ```
    mv ${HOME}/tls.crt ${HOME}/.sentinelnode/tls.crt
    mv ${HOME}/tls.key ${HOME}/.sentinelnode/tls.key
    ```

‎

11. Add/Recover an account key


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

13. Run the node

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
    


