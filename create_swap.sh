#!/bin/sh

# size of swapfile in mb
swapsize=1024

# do we have a swap file?
grep -q "swapfile" /etc/fstab

if [ $? -ne 0 ]; then
	echo 'No swap file available. Creating...'
	dd if=/dev/zero of=/var/1024MiB.swap bs=1024k count=1000
	#fallocate -l ${swapsize}g /var/1024MiB.swap
	chmod 600 /var/1024MiB.swap
	mkswap /var/1024MiB.swap
	swapon /var/1024MiB.swap
	echo '/var/1024MiB.swap  none  swap  sw  0 0' >> /etc/fstab
	swapon -a
	sysctl -w vm.swappiness=10
	echo vm.swappiness = 10 | tee -a /etc/sysctl.conf
else
	echo 'swapfile found. No changes made.'
fi

# show resulting swap file info
cat /proc/swaps
cat /proc/meminfo | grep Swap