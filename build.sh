#!/bin/bash

CONTAINERNAME=devcon

grep -e "NEWUSER=\w" Dockerfile

if [ $? -eq 1 ] 
then
	echo "Please set NEWUSER in Dockerfile";
	exit 1;
fi

echo "### container name set to: $CONTAINERNAME"

docker build ./ --tag code

echo "### image built"

export DOCKERGID=`cat /etc/group | grep docker | cut -d ':' -f 3`

echo "### Docker group ID detected as: $DOCKERGID"

echo "### starting container ..."

docker run 	--mount type=bind,src=/var/run/docker.sock,dst=/var/run/docker.sock 	\
		--mount type=bind,src=`pwd`/random.txt,dst=/var/run/random.txt,readonly	\
		--hostname $CONTAINERNAME --name $CONTAINERNAME --env DOCKERGID 	\
		--interactive --tty 							\
		  code

		
