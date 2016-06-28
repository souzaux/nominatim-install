#!/bin/sh

# size of swapfile in mb
# swapsize=1024
swapFile=2048MB.swap

# do we have a swap file?
grep -q ${swapFile} /etc/fstab

if [ $? -ne 0 ]; then
	echo 'No swap file available. Creating...'
	dd if=/dev/zero of=/var/${swapFile} bs=1024k count=1000
	#fallocate -l ${swapsize}g /var/1024MiB.swap
	chmod 600 /var/${swapFile}
	mkswap /var/${swapFile}
	swapon /var/${swapFile}
	echo '/var/${swapFile}  none  swap  sw  0 0' >> /etc/fstab
	swapon -a
	sysctl -w vm.swappiness=10
	echo vm.swappiness = 10 | tee -a /etc/sysctl.conf
else
	echo '${swapFile} found. No changes made.'
fi

# show resulting swap file info
cat /proc/swaps
cat /proc/meminfo | grep Swap