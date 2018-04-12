#!/bin/bash

CMD="exec /usr/bin/docker run --rm --name __CONTAINER_NAME__ \
	--net=__NETWORK__ \
	-p __API_PORT__:__API_PORT__ \
	__LINKS__ \
	__HOSTS__ \
	__VOLUMES__ \
	__IMAGE_NAME__"

echo $CMD
eval $CMD
