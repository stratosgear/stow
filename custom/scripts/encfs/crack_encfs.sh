#!/bin/sh

# usage: crackencfs.sh /path/to/encrypted/folder /path/to/mountpoint /path/to/wordlist
counter=1

while [ true ]; do
	# prepare tmp script
	echo echo $(head -n $counter $3 | tail -n 1) > /tmp/superduperword.sh
	chmod a+x /tmp/superduperword.sh
	encfs $1 $2 --extpass=/tmp/superduperword.sh
	if [ $? -eq 0 ]; then
		echo Key recovered - the password is: 
		/tmp/superduperword.sh
		exit
	fi
	echo Tried pass $counter: $(head -n $counter $3 | tail -n 1)
	counter=$(($counter + 1))
done
