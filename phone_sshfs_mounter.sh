#!/bin/bash

#### CONFIGURATION

export USB_TIMEOUT_SECONDS=1
export LAN_TIMEOUT_SECONDS=1
export ETH_TIMEOUT_SECONDS=1
export WIFI_TIMEOUT_SECONDS=2

export USB_PINEPHONE_IP=172.16.42.1
export LAN_PINEPHONE_IP=10.10.10.56
export ETH_PINEPHONE_IP=10.42.0.56
export WIFI_PINEPHONE_IP=10.10.10.76

export PINEPHONE_SSHFS_PATH=$HOME/pinephone_sshfs
export PINEPHONE_SSHFS_USER=user

trap "fusermount -q -u ${PINEPHONE_SSHFS_PATH}; rm ${PINEPHONE_SSHFS_PATH} -d; exit" INT

if [ -t 0 ] ; then
	echo "If you're running this program in the command line, you can safely stop it by pressing ctrl+c."
else
	sleep 6s #this sleep makes the notification display when you start this script at login
fi

export connected=0
while [ 1 == 1 ]
do
	if [ $(ping ${USB_PINEPHONE_IP} -c 1 -W 0.01 | grep -c ', 0% packet loss') -eq 1 ]; then
		if [ $(nmap ${USB_PINEPHONE_IP} -p 22 -Pn | grep 22 | grep -c open) -eq 1 ]; then		
			echo 'connected via usb'
			notify-send 'sshfs connected' 'Phone detected through usb, sshfs connecting' --icon=connect_creating
			mkdir -p ${PINEPHONE_SSHFS_PATH}
			sshfs ${PINEPHONE_SSHFS_USER}@${USB_PINEPHONE_IP}:/home/${PINEPHONE_SSHFS_USER} ${PINEPHONE_SSHFS_PATH} \
			-o max_conns=20 -f -o auto_unmount -o allow_other -o ServerAliveInterval=1 -o ServerAliveCountMax=${USB_TIMEOUT_SECONDS};
			rm ${PINEPHONE_SSHFS_PATH} -d
			notify-send 'sshfs disconnected' 'Phone no longer detected through usb, sshfs disconnecting' --icon=connect_no
			export connected=1
		fi
	fi
	

	if [ $(ping ${LAN_PINEPHONE_IP} -c 1 -W 0.01 | grep -c ', 0% packet loss') -eq 1 ]; then
		if [ $(nmap ${LAN_PINEPHONE_IP} -p 22 -Pn | grep 22 | grep -c open) -eq 1 ]; then
			echo 'connected via lan'
			notify-send 'sshfs connected' 'Phone detected through LAN, sshfs connecting' --icon=connect_creating
			mkdir -p ${PINEPHONE_SSHFS_PATH}
			sshfs ${PINEPHONE_SSHFS_USER}@${LAN_PINEPHONE_IP}:/home/${PINEPHONE_SSHFS_USER} ${PINEPHONE_SSHFS_PATH} \
			-o max_conns=20 -f -o auto_unmount -o allow_other -o ServerAliveInterval=1 -o ServerAliveCountMax=${LAN_TIMEOUT_SECONDS};
			rm ${PINEPHONE_SSHFS_PATH} -d
			notify-send 'sshfs disconnected' 'Phone no longer detected through LAN, sshfs disconnecting' --icon=connect_no
			export connected=1
		fi
	fi
	

	if [ $(ping ${ETH_PINEPHONE_IP} -c 1 -W 0.01 | grep -c ', 0% packet loss') -eq 1 ]; then
		if [ $(nmap ${ETH_PINEPHONE_IP} -p 22 -Pn | grep 22 | grep -c open) -eq 1 ]; then
			echo 'connected via lan from pc'
			notify-send 'sshfs connected' 'Phone detected through LAN, sshfs connecting' --icon=connect_creating
			mkdir -p ${PINEPHONE_SSHFS_PATH}
			sshfs ${PINEPHONE_SSHFS_USER}@${ETH_PINEPHONE_IP}:/home/${PINEPHONE_SSHFS_USER} ${PINEPHONE_SSHFS_PATH} \
			-o max_conns=20 -f -o auto_unmount -o allow_other -o ServerAliveInterval=1 -o ServerAliveCountMax=${ETH_TIMEOUT_SECONDS};
			rm ${PINEPHONE_SSHFS_PATH} -d
			notify-send 'sshfs disconnected' 'Phone no longer detected through LAN, sshfs disconnecting' --icon=connect_no
			export connected=1
		fi
	fi


	if [ $(ping $WIFI_PINEPHONE_IP -c 1 -W 0.5 | grep -c ', 0% packet loss') -eq 1 ]; then
		if [ $(nmap $WIFI_PINEPHONE_IP -p 22 -Pn | grep 22 | grep -c open) -eq 1 ]; then
			echo 'connected via wifi, may be spotty'
			while [ 1 -eq 1 ]
       			do
				if [ $(ping $USB_PINEPHONE_IP -c 1 -W 0.01 | grep -c ', 0% packet loss') -eq 1 ]; then
					if [ $(nmap $USB_PINEPHONE_IP -p 22 -Pn | grep 22 | grep -c open) -eq 1 ]; then	
						fusermount -u ${PINEPHONE_SSHFS_PATH}
					fi
				fi

				if [ $(ping $LAN_PINEPHONE_IP -c 1 -W 0.01 | grep -c ', 0% packet loss') -eq 1 ]; then
					if [ $(nmap $LAN_PINEPHONE_IP -p 22 -Pn | grep 22 | grep -c open) -eq 1 ]; then
						fusermount -u ${PINEPHONE_SSHFS_PATH}
					fi
				fi

				if [ $(ping $ETH_PINEPHONE_IP -c 1 -W 0.01 | grep -c ', 0% packet loss') -eq 1 ]; then
					if [ $(nmap $ETH_PINEPHONE_IP -p 22 -Pn | grep 22 | grep -c open) -eq 1 ]; then
						fusermount -u ${PINEPHONE_SSHFS_PATH}
					fi	
				fi
				sleep 1
			done &
			notify-send 'sshfs connected' 'Phone detected through wifi, sshfs connecting' --icon=connect_creating
			mkdir -p ${PINEPHONE_SSHFS_PATH}
			sshfs ${PINEPHONE_SSHFS_USER}@${WIFI_PINEPHONE_IP}:/home/${PINEPHONE_SSHFS_USER} ${PINEPHONE_SSHFS_PATH} \
			-o max_conns=20 -f -o auto_unmount -o allow_other -o ServerAliveInterval=1 -o ServerAliveCountMax=${WIFI_TIMEOUT_SECONDS};
			kill $!
			rm ${PINEPHONE_SSHFS_PATH} -d
			notify-send 'sshfs disconnected' 'Phone no longer detected through wifi, or a faster connection was detected. sshfs disconnecting' --icon=connect_no
			export connected=1
		fi			
	fi
	
	if [ $connected -eq 0 ]; then
		echo cannot reach phone
		sleep 1
	fi
done
