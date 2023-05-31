#!/bin/bash
set -e

hn=$(hostname)
hn=${hn%%.*}
tmp=$(sha256sum <<< "${hn}dictxiongdockerfiles")
ula_prefix=fddc:3908:f2a1:${tmp:0:4}
docker network create -d bridge --subnet 172.18.1.1/24 --ipv6 --subnet $ula_prefix::1/64 bridge2
ufw route allow from $ula_prefix::/64 comment "nat6 docker bridge2"
ufw route allow to $ula_prefix::/64 comment "expose6 docker bridge2"
cat <<EOF
you may need to run/conf:
ip6tables -t nat -A POSTROUTING -s $ula_prefix::/64 -j MASQUERADE
EOF
