
echo "keyname"
read walletname < /dev/tty

sed 's/^\(from\s*=\s*\).*$/\1\"'`echo $walletname`'\"/' ${HOME}/.sentinelnode/config.toml
