#!/bin/bash

function getParams() {
	NEW=()
	X=1
	for ITEM in "$@"; do
		if [[ X -gt 1 ]]; then NEW=("${NEW[@]}" $ITEM); fi
		((X=$X+1))
	done
	echo "${NEW[@]}"
}

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

function twoPartParamValue() {
	ARGS=("$@")
	INDEX=$(indexOf ${ARGS[@]})
	((INDEX=$INDEX+1))
	echo ${ARGS[$INDEX]}
}