#!/bin/bash
#
 
LOG=/home/ubuntu/log

sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get install iperf iperf3 -y

echo "iperf3 -c <ip> -P 100 -M <MTU - 50 bytes encapsulation overhead> -t 60 -i 10" >> $LOG
echo "$(date) [INFO] IPERF3 installed ..." >> $LOG

sudo iperf3 -s -D

apt-get -y install build-essential
apt-get -y install git
git clone https://github.com/Microsoft/ntttcp-for-linux
cd ntttcp-for-linux/src
make && make install

echo "$(date) [INFO] NTTTCP installed ..." >> $LOG

ntttcp -H -r -m 100,* -D --show-tcp-retrans --show-nic-packets eth0 --show-dev-interrupts eth0 -V -O /tmp/ntttcp.log

echo "NTTTCP started in RECEIVER/SERVER mode, in the background, 100 threads, all interfaces and logging info to /tmp/ntttcp.log" >> $LOG
echo "for the client use ntttcp -s <ip address>; for threads use -P, -n or -l" >> $LOG

echo "INSTALLING NETPERF" >> $LOG
apt-get install netperf
echo "netperf -H 10.142.0.93 -l -1000 -t TCP_RR -w 10ms -b 1 -v 2 -- -O min_latency,mean_latency,max_latency,stddev_latency,transaction_rate" >> $LOG
echo "NETPERF INSTALLED" >> $LOG

