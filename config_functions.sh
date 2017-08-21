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

	F=0
	NEXT=""

	for ITEM in $(cat $SRCFILE | grep -ne "^\["); do
		if [[ $F == 1 ]]; then
			NEXT=$(echo $ITEM | sed -e 's/:.*$//')
			break
		fi

		if [[ $(echo $ITEM | grep -- "\[${BLOCKNAME}\]") ]]; then
			F=1
		fi
	done

	if [[ $NEXT != '' ]]; then
		TMPFILE="${SRCFILE}___"
		cp $SRCFILE $TMPFILE
		COUNT=$(cat $TMPFILE | wc -l)

		sed -i.bak "${NEXT},${COUNT}d" $TMPFILE
		rm $TMPFILE.bak
	else
		TMPFILE=$SRCFILE
	fi

	CMD="/usr/bin/awk '/^\[${BLOCKNAME}\]/{f=1} f==1&&/^${VARNAME}=/{print;exit}' ${TMPFILE}"
	SEDBIN=$(which sed)
	echo $(eval $CMD | eval "$SEDBIN -e 's/^$VARNAME=//'")

	if [[ $NEXT != '' ]]; then
		rm $TMPFILE
	fi
}
