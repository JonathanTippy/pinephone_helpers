#!/bin/bash

#### CONFIGURATION

export USB_TIMEOUT_SECONDS=3
export LAN_TIMEOUT_SECONDS=3
export ETH_TIMEOUT_SECONDS=3
export WIFI_TIMEOUT_SECONDS=3

export USB_PINEPHONE_IP=172.16.42.1
export LAN_PINEPHONE_IP=10.10.10.56
export ETH_PINEPHONE_IP=10.42.0.56
export WIFI_PINEPHONE_IP=10.10.10.76

export PINEPHONE_SSHFS_PATH=$HOME/pinephone_sshfs
export PINEPHONE_SSHFS_USER=user

trap "fusermount -q -u -z ${PINEPHONE_SSHFS_PATH}; rm ${PINEPHONE_SSHFS_PATH} -d -f; rm /tmp/.pinephone_sshfs_wifi -f; rm /tmp/.pinephone_sshfs_new_connection_notified -f; exit" INT

if [ -t 0 ] ; then
	echo "If you're running this program in the command line, you can safely stop it by pressing ctrl+c."
else
	sleep 6s #this sleep makes the notification display when you start this script at login
fi

while true
do
	while true
	do
		if [ $(ping ${USB_PINEPHONE_IP} -c 1 -W 0.01 | grep -c ', 0% packet loss') -eq 1 ]; then
			if [ $(nmap ${USB_PINEPHONE_IP} -p 22 -Pn | grep 22 | grep -c open) -eq 1 ]; then		
				echo 'connected via usb'
				notify-send 'sshfs connected' 'Phone detected through usb, sshfs connecting' --icon=connect_creating -a "sshfs manager"
				mkdir -p ${PINEPHONE_SSHFS_PATH}
				sshfs ${PINEPHONE_SSHFS_USER}@${USB_PINEPHONE_IP}:/home/${PINEPHONE_SSHFS_USER} ${PINEPHONE_SSHFS_PATH} \
				-o max_conns=20 -f -o auto_unmount -o allow_other -o ServerAliveInterval=1 -o ServerAliveCountMax=${USB_TIMEOUT_SECONDS};
				if [ $? -eq 1 ]; then
					notify-send 'sshfs disconnected' 'The usb connection was lost.' --icon=connect_no -a "sshfs manager"
				else
					notify-send 'sshfs disconnected' 'The sshfs was unmounted.' --icon=connect_no -a "sshfs manager"			
				fi
				rm ${PINEPHONE_SSHFS_PATH} -d -f
				break
			fi
		fi
		

		if [ $(ping ${LAN_PINEPHONE_IP} -c 1 -W 0.01 | grep -c ', 0% packet loss') -eq 1 ]; then
			if [ $(nmap ${LAN_PINEPHONE_IP} -p 22 -Pn | grep 22 | grep -c open) -eq 1 ]; then
				echo 'connected via lan'
				notify-send 'sshfs connected' 'Phone detected through LAN, sshfs connecting' --icon=connect_creating -a "sshfs manager"
				mkdir -p ${PINEPHONE_SSHFS_PATH}
				sshfs ${PINEPHONE_SSHFS_USER}@${LAN_PINEPHONE_IP}:/home/${PINEPHONE_SSHFS_USER} ${PINEPHONE_SSHFS_PATH} \
				-o max_conns=20 -f -o auto_unmount -o allow_other -o ServerAliveInterval=1 -o ServerAliveCountMax=${LAN_TIMEOUT_SECONDS};
				if [ $? -eq 1 ]; then
					notify-send 'sshfs disconnected' 'The lan connection was lost.' --icon=connect_no -a "sshfs manager"
				else
					notify-send 'sshfs disconnected' 'The sshfs was unmounted.' --icon=connect_no -a "sshfs manager"			
				fi
				rm ${PINEPHONE_SSHFS_PATH} -d -f
				break
			fi
		fi
		

		if [ $(ping ${ETH_PINEPHONE_IP} -c 1 -W 0.01 | grep -c ', 0% packet loss') -eq 1 ]; then
			if [ $(nmap ${ETH_PINEPHONE_IP} -p 22 -Pn | grep 22 | grep -c open) -eq 1 ]; then
				echo 'connected via lan from pc'
				notify-send 'sshfs connected' 'Phone detected through ethernet, sshfs connecting' --icon=connect_creating -a "sshfs manager"
				mkdir -p ${PINEPHONE_SSHFS_PATH}
				sshfs ${PINEPHONE_SSHFS_USER}@${ETH_PINEPHONE_IP}:/home/${PINEPHONE_SSHFS_USER} ${PINEPHONE_SSHFS_PATH} \
				-o max_conns=20 -f -o auto_unmount -o allow_other -o ServerAliveInterval=1 -o ServerAliveCountMax=${ETH_TIMEOUT_SECONDS};
				if [ $? -eq 1 ]; then
					notify-send 'sshfs disconnected' 'The ethernet connection was lost.' --icon=connect_no -a "sshfs manager"
				else
					notify-send 'sshfs disconnected' 'The sshfs was unmounted.' --icon=connect_no -a "sshfs manager"			
				fi
				rm ${PINEPHONE_SSHFS_PATH} -d -f
				break
			fi
		fi


		if [ $(ping $WIFI_PINEPHONE_IP -c 1 -W 0.5 | grep -c ', 0% packet loss') -eq 1 ]; then
			if [ $(nmap $WIFI_PINEPHONE_IP -p 22 -Pn | grep 22 | grep -c open) -eq 1 ]; then
				echo 'connected via wifi, may be spotty'
				touch /tmp/.pinephone_sshfs_wifi
				while [ -f /tmp/.pinephone_sshfs_wifi ]
       				do
					#echo "wifi_connected is $WIFI_CONNECTED"
					if [ $(ping $USB_PINEPHONE_IP -c 1 -W 0.01 | grep -c ', 0% packet loss') -eq 1 ]; then
						if [ $(nmap $USB_PINEPHONE_IP -p 22 -Pn | grep 22 | grep -c open) -eq 1 ]; then	
							fusermount -u ${PINEPHONE_SSHFS_PATH}
							if [ $(echo $?) -eq 0 ]; then
								notify-send 'sshfs disconnected' 'A usb connection was detected. sshfs disconnecting' --icon=connect_no -a "sshfs manager"
								rm /tmp/.pinephone_sshfs_new_connection_notified -f
								break
							else																	
								if [ ! -f /tmp/.pinephone_sshfs_new_connection_notified ]; then							
									notify-send 'sshfs could not be disconnected' 'A usb connection was detected, but the sshfs is active.' --icon=connect_no -a "sshfs manager"
									touch /tmp/.pinephone_sshfs_new_connection_notified
								fi
							fi
						fi
					fi
	
					if [ $(ping $LAN_PINEPHONE_IP -c 1 -W 0.01 | grep -c ', 0% packet loss') -eq 1 ]; then
						if [ $(nmap $LAN_PINEPHONE_IP -p 22 -Pn | grep 22 | grep -c open) -eq 1 ]; then
							fusermount -u ${PINEPHONE_SSHFS_PATH}
							if [ $(echo $?) -eq 0 ]; then
								notify-send 'sshfs disconnected' 'A lan connection was detected. sshfs disconnecting' --icon=connect_no -a "sshfs manager"
								rm /tmp/.pinephone_sshfs_new_connection_notified -f
								break
							else
								if [ ! -f /tmp/.pinephone_sshfs_new_connection_notified ]; then													
									notify-send 'sshfs could not be disconnected' 'A lan connection was detected, but the sshfs is active.' --icon=connect_no -a "sshfs manager"
									touch /tmp/.pinephone_sshfs_new_connection_notified
								fi
							fi
						fi
					fi
	
					if [ $(ping $ETH_PINEPHONE_IP -c 1 -W 0.01 | grep -c ', 0% packet loss') -eq 1 ]; then
						if [ $(nmap $ETH_PINEPHONE_IP -p 22 -Pn | grep 22 | grep -c open) -eq 1 ]; then
							fusermount -u ${PINEPHONE_SSHFS_PATH}
							if [ $(echo $?) -eq 0 ]; then
								notify-send 'sshfs disconnected' 'An ethernet connection was detected. sshfs disconnecting' --icon=connect_no -a "sshfs manager"
								rm /tmp/.pinephone_sshfs_new_connection_notified -f
								break
							else
								if [ ! -f /tmp/.pinephone_sshfs_new_connection_notified ]; then																			
									notify-send 'sshfs could not be disconnected' 'An ethernet connection was detected, but the sshfs is active.' --icon=connect_no -a "sshfs manager"
									touch /tmp/.pinephone_sshfs_new_connection_notified
								fi
							fi
						fi	
					fi
					sleep 1
				done &
				notify-send 'sshfs connected' \
				'Phone detected through wifi, sshfs connecting. If a faster connection is detected, and the sshfs is not in use, it will be remounted on the faster connection.' \
				--icon=connect_creating -a "sshfs manager"
				mkdir -p ${PINEPHONE_SSHFS_PATH}
				sshfs ${PINEPHONE_SSHFS_USER}@${WIFI_PINEPHONE_IP}:/home/${PINEPHONE_SSHFS_USER} ${PINEPHONE_SSHFS_PATH} \
				-o max_conns=20 -f -o auto_unmount -o allow_other -o ServerAliveInterval=1 -o ServerAliveCountMax=${WIFI_TIMEOUT_SECONDS};
				if [ $? -eq 1 ]; then
					notify-send 'sshfs disconnected' 'The wifi connection was lost.' --icon=connect_no -a "sshfs manager"
				fi
				rm /tmp/.pinephone_sshfs_wifi -f
				rm /tmp/.pinephone_sshfs_new_connection_notified -f
				rm ${PINEPHONE_SSHFS_PATH} -d -f
				break
			fi			
		fi

		echo cannot reach phone
		sleep 1
	done
done