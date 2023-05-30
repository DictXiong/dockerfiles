#!/bin/bash
set -e

test -f /etc/ssh/ssh_host_rsa_key || ssh-keygen -A
crond
/usr/sbin/sshd
bash
