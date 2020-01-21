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

# This variable will basically Keep track of the number of times a report is printed.
report_number=0

#This is an infinite loop that logs some data into the log file every 15 seconds.
while true; do

	crt_log=() #Keeping track of files created into this array
        del_log=() #Keeping track of files deleted into this array
        mod_log=() #Keeping track of files modified into this array
	
        #Saving the file inside the trashCan dir into a temporary variable
	files=($(ls -1 $DIR))
	
	# This an associative array to store hash values of each file initially
	declare -A init_state
	for f in ${files[@]}; do
		init_state[$f]=$(md5sum <$DIR/$f)
	done
	
        #After every 15 seconds check the state of files inside the trashCan dir 
	sleep 15
	
        # Current files in trashCan directory
	current_files=($(ls -1 $DIR))
	
       # This is an associative array to store hash values of each file currently
	declare -A current_hashes
	for f in ${current_files[@]}; do
		current_hashes[$f]=$(md5sum <$DIR/$f)
	done
	
	for filename in ${files[@]}; do # looping through initial files and comparing with current files in the directory
		
		if [[ -d $DIR/$filename ]]; then # Skipping directories
			continue
		fi
		
                # Keeping track of number of processed files 
		counter=0
		for current_file in ${current_files[@]}; do # Going through current files each compared with filename
			if [[ -d $DIR/$current_file ]]; then # Skipping directories
				continue
			fi
                 # If file is in current files, check if it has been modified by comparing the hash values
			if [[ $filename == $current_file ]]; then
				if [[ ${init_state[$filename]} != ${current_hashes[$current_file]} ]]; then
					mod_log+=($filename)
				fi 
                # No need to check other files in current files
				break
			fi
			# Incrementing the counter
			counter=$(($counter+1))
		done
             # If file is not in current files, then it must have been deleted
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

        #Save report log data into a file called logs.txt then display those data to screen after every 15s
        echo "Monitor Logs#$report_number: " >> logs.txt #Write the data into the file.
	echo "Monitor Logs timestamp: $current_time " >> logs.txt
	echo "Num of files created (${#crt_log[*]}): ${crt_log[*]}" >> logs.txt
	echo "Num of files modified (${#mod_log[*]}): ${mod_log[*]}" >> logs.txt
	echo "Num of files deleted (${#del_log[*]}): ${del_log[*]}" >> logs.txt
	echo "--------------------------" >> logs.txt
        cat logs.txt #Display the content of the log file to screen

done




