#!/bin/bash
set -e

hn=$(hostname)
hn=${hn%%.*}
tmp=$(sha256sum <<< "${hn}dictxiongjumpserver")
ula_prefix=fddd:3908:f2a1:${tmp:0:4}
ufw route allow from fddd:3908:f2a1::/48 comment "nat6 docker bridge2"
ufw route allow to fddd:3908:f2a1::/48 comment "expose6 docker bridge2"

docker pull dictxiong/jumpserver
docker network create -d bridge --subnet 172.18.1.1/24 --ipv6 --subnet ${ula_prefix}::1/64 bridge2
docker run -itd --restart always -p 36122:22 --hostname jump-$hn --network bridge2 --ip 172.18.1.2 --ip6 ${ula_prefix}::2 --name jumpserver dictxiong/jumpserver

ifname=$(echo -n br-;docker network inspect bridge2 | grep Id | awk -F '"' '{print $4}' | awk '{print substr($1,1,12)}')
cat <<EOF
you may need to run:
ip6tables -t nat -A POSTROUTING -s fddd:3908:f2a1::/48 -j MASQUERADE
ip6tables -t nat -A PREROUTING ! -i $ifname -p tcp -m tcp --dport 36122 -j DNAT --to-destination "[${ula_prefix}::2]:22"
EOF

