#!/bin/bash
function batch_convert(){
	for file in `ls $1`
	do
		if [ -d $1"/"$file ]
		then
			batch_convert $1"/"$file
		else
			dos2unix $1"/"$file
		fi
	done
}

batch_convert ~/.vim
# batch_convert ~/vundle
