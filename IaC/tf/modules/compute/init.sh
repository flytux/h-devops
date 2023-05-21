#!/bin/bash
useradd mtp
echo 'Rnfjrl@0' | passwd --stdin mtp
cp -a /etc/sudoers /etc/sudoers.bak
echo "mtp ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers

useradd hroadm
echo 'Wlsekffo!@0' | passwd --stdin hroadm
cp -a /etc/sudoers /etc/sudoers.bak
 echo "mtp ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers