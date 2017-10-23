#!/bin/bash

function indexOf() {
	local HAYSTACK=("$@")
	((LAST_IDX=${#HAYSTACK[@]} - 1))
	local NEEDLE=${HAYSTACK[LAST_IDX]}
	unset HAYSTACK[LAST_IDX]

	INDEX=-1
	for ITEM in "${HAYSTACK[@]}" ; do
		((INDEX=$INDEX+1))
		if [[ "$ITEM" == "$NEEDLE" ]]; then
			echo $INDEX
			return
		fi
	done
	echo -1
}

function inArray() {
	if [[ $(indexOf "$@") != -1 ]]; then
		echo 1
	else
		echo 0
	fi
}

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
