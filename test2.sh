
echo "keyname"
read username < /dev/tty

sed -i 's/^\(from\s*=\s*\).*$/\1\"'`echo ${username}`'\"/' ${HOME}/.sentinelnode/config.toml
