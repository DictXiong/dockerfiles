#!/bin/bash
set -e

hn=$(hostname)
hn=${hn%%.*}
tmp=$(sha256sum <<< "${hn}dictxiongjumpserver")
ula_prefix=fddd:3908:f2a1:${tmp:0:4}

docker pull dictxiong/jumpserver
docker network create -d bridge --subnet 172.18.1.1/24 --ipv6 --subnet ${ula_prefix}::1/64 bridge2
docker run -itd --restart always -p 36122:22 --hostname jump-$hn --network bridge2 --ip 172.18.1.2 --ip6 ${ula_prefix}::2 --name jumpserver dictxiong/jumpserver
