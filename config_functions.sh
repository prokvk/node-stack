#!/bin/bash

function explode() {
	DELIM=$1
	STR=$2
	IFS=$DELIM read -ra PARTS <<< "$STR"
	echo "${PARTS[*]}"
}

function parseValue() {
	SRCFILE=$1
	VARNAME=$2
	LINE=$(cat $SRCFILE | grep "${VARNAME}=")
	PARTS=($(explode '=' $LINE))
	echo ${PARTS[1]}
}

function parseBlockValue() {
	SRCFILE=$1
	VARNAME=$2
	BLOCKNAME=$3

	CMD="/usr/bin/awk '/^\[${BLOCKNAME}\]/{f=1} f==1&&/^${VARNAME}=/{print;exit}' ${SRCFILE}"
	echo $(eval $CMD | /bin/sed -e 's/^[^=]\+=//')
}