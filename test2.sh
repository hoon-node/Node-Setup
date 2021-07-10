
echo "keyname"
read walletname < /dev/tty

sed '/from = "/a $walletname' ${HOME}/.sentinelnode/config.toml
