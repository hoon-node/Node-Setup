
echo "keyname"
read username < /dev/tty

awk '1;/from = "/{ print "add one line"}' ${HOME}/.sentinelnode/config.toml
