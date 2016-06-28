#!/bin/sh

# size of swapfile in mb
# swapsize=1024
swapFile=1024MB.swap

# do we have a swap file?
grep -q ${swapFile} /etc/fstab

if [ $? -ne 0 ]; then
	echo 'No swap file available. Creating...'
	sudo dd if=/dev/zero of=/${swapFile} bs=1024k count=1000
	#fallocate -l ${swapsize}g /var/1024MiB.swap
	sudo chmod 600 /${swapFile}
	sudo mkswap /${swapFile}
	sudo swapon /${swapFile}
	echo '/${swapFile}  none  swap  sw  0 0' >> /etc/fstab
	sudo swapon -a
	# Tweak your Swap Settings
	sudo sysctl -w vm.swappiness=10
	sudo sysctl vm.vfs_cache_pressure=50
	echo vm.swappiness = 10 | tee -a /etc/sysctl.conf
else
	echo '${swapFile} found. No changes made.'
fi

# show resulting swap file info
cat /proc/swaps
cat /proc/meminfo | grep Swap