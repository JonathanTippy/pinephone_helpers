#!/bin/bash
read -p "this program requires that your drive be formatted to f2fs. If it is not, format it before you continue.
" NULL

read -p "please provide the device, for instance </dev/mmcblk0p1>.
" SD_CARD_DEVICE

read -p "please list the names of the folders in $HOME to be located on the SD card, for instance <Pictures>. After each name, press space. when all the names have been inputted, press enter.
" -a WHICH_FILES_GO_TO_SD_CARD_ARRAY

echo "verifying the files exist..."

export MISSING=0

for nTH_FILE in "${WHICH_FILES_GO_TO_SD_CARD_ARRAY[@]}"

		do
			if [ "$(ls -d $HOME/* | grep -c ./$nTH_FILE$)" -eq "0" ]; then

				export MISSING=1

				echo "$nTH_FILE is missing from home."

			else

				echo "found $nTH_FILE in home."

			fi
		done

if [ "${MISSING}" -eq "0" ]; then
	echo "all files were found, continuing."

else
	echo "some files were not found, exiting."

	exit
fi

sudo umount $SD_CARD_DEVICE

mkdir $HOME/SDCard

rm $HOME/.fstab_stuff

touch $HOME/.fstab_stuff

echo "$SD_CARD_DEVICE  $HOME/SDCard f2fs defaults 0 1" >> $HOME/.fstab_stuff

sudo mount $SD_CARD_DEVICE $HOME/SDCard

read -p "would you like to keep the versions present on the root drive, or use the versions present on the sd card? keep|use
" WHICH_FILES_TO_USE

if [ "${WHICH_FILES}" == "keep" ]; then

	read -p "are you sure? all matching files on the sd card will be lost. continue? yes|no
" WEATHER_TO_CONTINUE

	if [ "${WEATHER_TO_CONTINUE}" == "yes" ]; then

		for nTH_FILE in "${WHICH_FILES_GO_TO_SD_CARD_ARRAY[@]}"

		do

			rm $HOME/SDCard/$nTH_FILE -R

			mkdir $HOME/SDCard/$nTH_FILE

			cp $HOME/$nTH_FILE $HOME/SDCard/ -R -a

			echo "$HOME/SDCard/$nTH_FILE $HOME/$nTH_FILE none defaults,bind 0 0" >> $HOME/.fstab_stuff

		done

	fi

else

	echo "no files will be lost, you can access origional versions of the files by unmounting the sd card."

	for nTH_FILE in "${WHICH_FILES_GO_TO_SD_CARD_ARRAY[@]}"

	do

		echo "$HOME/SDCard/$nTH_FILE $HOME/$nTH_FILE none defaults,bind 0 0" >> $HOME/.fstab_stuff
	
	done

fi



echo "the following fstab entry has been generated. it will be appended to the end of your preexisting fstab. continue? yes/no"

cat $HOME/.fstab_stuff

read WEATHER_TO_CONTINUE

if [ "${WEATHER_TO_CONTINUE}" == "yes" ]; then

	cat $HOME/.fstab_stuff | sudo tee -a /etc/fstab

	rm $HOME/.fstab_stuff

	sudo mount -a

else

	rm $HOME/.fstab_stuff

	echo "exiting..."

	exit

fi
