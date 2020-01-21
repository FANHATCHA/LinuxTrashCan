#!/bin/bash

#Author: Kone Fanhatcha
#Date: 10/7/2019

#Delimiter
delimiter="*********************************************"

#miscellaneous

bold="\033[1m" 
normal="\033[0m"
green="\e[32m"
date=$(date +"%Y-%m-%d") # date command substitution
DIR=~/.trashCan

#Stater function
function starter(){

#Personal information

name="KONE FANHATCHA"
student_id=S1803435 

#System Information

bash_version=$BASH_VERSION
machtype=$MACHTYPE
current_user_loggedIn=$USER
hostname=$HOSTNAME

#Welcome message

welcome_msg="******* Welcome to safeDel 1.0 ************"


echo -e  "$bold $welcome_msg $normal"
printf "\t Student name:\t%s\n" "$name"
printf "\t Student ID:\t%s\n" $student_id
printf "\t Current user logged In:\t%s\n" $current_user_loggedIn
printf "\t Bash Version:\t%s\n" $bash_version
printf "\t System type:\t%s\n" $machtype
printf "\t Hostname:\t%s\n" $hostname
printf "\t Date:\t%s\n" $date

}
starter
echo -e "$delimiter"


report_number=0

while true; do
	mod_log=()
	del_log=()
	crt_log=()
	
	files=($(ls -1 $DIR))
	
	declare -A init_state
	for f in ${files[@]}; do
		init_state[$f]=$(md5sum <$DIR/$f)
	done
	
	sleep 15
	
	current_files=($(ls -1 $DIR))
	
	declare -A current_hashes
	for f in ${current_files[@]}; do
		current_hashes[$f]=$(md5sum <$DIR/$f)
	done
	
	for filename in ${files[@]}; do
		
		if [[ -d $DIR/$filename ]]; then
			continue
		fi
		
		counter=0
		for current_file in ${current_files[@]}; do
			if [[ -d $DIR/$current_file ]]; then
				continue
			fi
			if [[ $filename == $current_file ]]; then
				if [[ ${init_state[$filename]} != ${current_hashes[$current_file]} ]]; then
					mod_log+=($filename)
				fi 
				break
			fi
			
			counter=$(($counter+1))
		done
		if [[ $counter == ${#current_files[@]} ]]; then
			del_log+=($filename)
		fi
	done
	
	for cur_file in ${current_files[@]}; do
		count=0
		for file_name in ${files[@]}; do
			if [[ $file_name == $cur_file ]]; then
				break
			fi
			count=$(($count+1))
		done
		if [[ $count == ${#files[@]} ]]; then
			crt_log+=($cur_file)
		fi
	done
	
	current_time=$(date "+%Y.%m.%d-%H.%M.%S")
        report_number=$(($report_number+1))
        echo "Monitor Logs#$report_number: " >> logs.txt
	echo "Monitor Logs timestamp: $current_time " >> logs.txt
	echo "Num of files created (${#crt_log[*]}): ${crt_log[*]}" >> logs.txt
	echo "Num of files modified (${#mod_log[*]}): ${mod_log[*]}" >> logs.txt
	echo "Num of files deleted (${#del_log[*]}): ${del_log[*]}" >> logs.txt
	echo "--------------------------" >> logs.txt
        cat logs.txt

done




