#!/bin/bash
set -e

suffix=2
ip4=$(docker network inspect bridge2 | grep Subnet | grep /24 | awk -F '"' '{print $4}' | awk -F '1/24' '{print $1}')$suffix
ip6=$(docker network inspect bridge2 | grep Subnet | grep /64 | awk -F '"' '{print $4}' | awk -F '1/64' '{print $1}')$suffix

docker pull dictxiong/jumpserver
docker run -itd --restart always -p 36122:22 --hostname jump-$(hostname | awk -F '.' '{print $1}') --network bridge2 --ip $ip4 --ip6 $ip6 --name jumpserver dictxiong/jumpserver

ifname=$(echo -n br-;docker network inspect bridge2 | grep Id | awk -F '"' '{print $4}' | awk '{print substr($1,1,12)}')
cat <<EOF
you may need to run/conf:
ip6tables -t nat -A PREROUTING ! -i $ifname -p tcp -m tcp --dport 36122 -j DNAT --to-destination "[$ip6]:22"
EOF

