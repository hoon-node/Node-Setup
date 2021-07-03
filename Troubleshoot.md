## When trying to run the node:


E:	Error: account does not exist with address sent1xxx

S:	Make sure you have a few DVPN in your created wallet

--------------------------------------------------------------------------------------

E:	Error: invalid section node: remote_url port cannot be empty

S:	Edit your config.toml and add the remote URL

```
https://<PUBLIC_IP>:<API_PORT>
https://<DOMAIN>:<API_PORT>
https://<DOMAIN>
```

--------------------------------------------------------------------------------------

E: 	Error: invalid remot_url: parse "0.0.0.0:8585": invalid URI for request

S: 	Your remote URL in your config file should have following format 
```
https://<PUBLIC_IP>:<API_PORT>
https://<DOMAIN>:<API_PORT>
https://<DOMAIN>
```

--------------------------------------------------------------------------------------

E: 	ERR Failed to register node error="All attempts fail:\n#1: signature verification failed; please verify account number (6640) and chain-id (sentinelhub-2)

S: 	Edit the network chain ID in your config file to
	id = "sentinelhub-2"

--------------------------------------------------------------------------------------

E: 	[#] ip link add wg0 type wireguard
	RTNETLINK answers: Not supported
	Unable to access interface: Protocol not supported
	[#] ip link delete dev wg0
	Cannot find device "wg0"
	Error: exit status 1

S: 	On Debian 10 you have to add the backport repository before installing wireguard

--------------------------------------------------------------------------------------


## When running the openssl req command on mac:


E: 	parameter error "ec_paramgen_curve:prime256v1"

S: 	Since Mac comes with it's own version of ssl engine LibreSsl that it defaults to you have to put openssl in its path
	run echo 'export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"' >> ~/.zshrc or
	echo 'export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"' >> ~/.bashrc depending on what you use

--------------------------------------------------------------------------------------
