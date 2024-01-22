#!/bin/bash  
echo "Start script for default"
 
## set timedate
timedatectl set-timezone "Asia/Seoul"
 
## stop & disable firewalld
systemctl stop firewalld
systemctl disable firewalld


