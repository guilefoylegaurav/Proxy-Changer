#! /bin/bash
declare -A NETWORKS
NETWORKS["hostel"]='172.16.199.40:8080'
NETWORKS["lab"]='172.16.199.20:8080'

COMMAND=${NETWORKS["hostel"]}
GENERAL_PROXY='/etc/profile.d/proxy.sh'
APT_PROXY='/etc/apt/apt.conf.d/99HttpProxy'
HANDSHAKES='/etc/apt/apt.conf.d/05proxies'
CURL_PROXY='$HOME/.curlrc'
WGET_PROXY='/etc/wgetrc'
if [ "$1" == "lab" ]
then
  COMMAND=${NETWORKS["lab"]}
fi

echo "export ftp_proxy=ftp://${COMMAND}
export http_proxy=http://${COMMAND}
export https_proxy=https://${COMMAND}
export socks_proxy=https://${COMMAND}" > $GENERAL_PROXY

echo "Acquire::http::proxy \"http:${COMMAND}\";
Acquire::https::proxy \"http:${COMMAND}\";" > $APT_PROXY

echo "http_proxy = http://${COMMAND}
https_proxy = https://${COMMAND}" > $WGET_PROXY

sudo -u "$2" git config --global http.proxy "http://${COMMAND}"
sudo -u "$2" git config --global https.proxy "https://${COMMAND}" 