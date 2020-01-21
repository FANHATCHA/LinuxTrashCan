#!/bin/bash

#Author: Kone Fanhatcha
#Date: 10/7/2019

name="KONE FANHATCHA"

#Delimiter
delimiter="*********************************************"

#miscellaneous

bold="\033[1m" 
normal="\033[0m"
green="\e[32m"
red_blink="\033[5;31;403"
date=$(date +"%Y-%m-%d") # date command substitution
DIR=~/.trashCan


if [[ ! -d $DIR ]]; then
         mkdir $DIR && touch $DIR/bin_{1..10}.txt
         echo -e "${green} trashCan created successfully ! $normal"
fi

function size_warning(){
	if [[ $(du -bs $DIR/ | cut -f 1) -gt 1000 ]]; then
		echo "The total disk usage of your trashCan directory has reached 1Kbytes"
	fi
}

size_warning

trap terminate SIGINT
terminate(){
	number_of_files=0
	
	if [[ "$(ls -A $DIR/)" ]]; then
		
		for file_or_dir in $DIR/*; do
			if [[ -f $file_or_dir ]]; then
				number_of_files=$(($number_of_files + 1))
			fi
		done
	fi
	
	echo -e "${green} safeDel progam is being closed ... ! $normal"
	echo "You currently have $number_of_files regular files in the trashCan."
        echo "Goodbye ! $name"
        exit 0
	
}


function starter(){

#Personal information


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

#manual

function manual(){

echo -e  "$bold safeDel user manual. Please select an option from the list $normal"	 # -e as I'll echo with escaping string 
echo
echo -en "${green} safeDel.sh -l: $normal" " Output a list on screen of the contents of the trashCan directory.""\n"
echo -en "${green} safeDel.sh -r filename: $normal" "Get a specified file, from the trashCan directory and place it in the current directory.""\n"
echo -en "${green} safeDel.sh -d: $normal" "Delete interactively the contents of the trashCan directory.""\n"
echo -en "${green} safeDel.sh –t: $normal" "Display total usage in bytes of the trashCan directory for the user of the trashCan.""\n"
echo -en "${green} safeDel.sh –m: $normal" "Start monitor script process.""\n"
echo -en "${green} safeDel.sh –k: $normal" "Kill current user’s monitor script processes.""\n"
echo
exit 0

}



# safeDel.sh -l list file 
function list_files(){
	
	  echo -e "${green} List of files in trashCan $normal"
	  if [[ "$(ls -A $DIR)" ]]; then
          echo "------------------------------------"
		for list_files in $DIR/*; do
			local file_name=$(basename $list_files)
			local file_size=$(du -b $list_files | cut -f1)
			local file_type=$(file $list_files | cut -d " " -f 2)
			
			echo "| $file_name | $file_size bytes | $file_type |"
		done
        echo "------------------------------------"
	else
	       echo "Sorry trashCan is empty !"
	fi
	  exit 0
	
}

#recover a file

function recover(){

	 if [[ "$(ls -A $DIR/)" ]]; then
		if [[ -e $DIR/$1 || -d $DIR/$1 ]]; then
			mv $DIR/$1 .
                        echo -e "${green} Recovered successfully ! $normal"
		else
			echo "Sorry file not found ! try another filename"
		fi
	else
		echo "Sorry trashCan is empty !"
	fi
	  exit 0 
}

function delete(){

   read -p "Warning: Are you sure ? this command will delete all the content of trashCan permanently !" ANSWER
       case "$ANSWER" in
          [yY] | [yY][eE][sS])
	if [[ "$(ls -A $DIR/)" ]]; then
		rm -ir $DIR/
                echo -e "${green} Deleted successfully ! $normal"
                exit 0 
	fi
     ;;
       [nN] | [nN][oO])
       exit 0
     ;;
   *)
     echo "Please enter y/yes or n/no !"
       exit 0 
esac
}

function total_usage(){
	local total_disk_usage=$(du -bs $DIR/ | cut -f 1)
        echo -e "${green} Total Disk usage is: $total_disk_usage bytes $normal"
        exit 0
}


function kill_monitor_logs(){
	pkill monitor.sh
}

   #options

	while getopts :lr:dtmkh OPTIONS #options
	do
	  case $OPTIONS in
	     l) 
	     	list_files
	     ;;
	     r) 
	     	recover $OPTARG
	     ;;
	     d) 
	     	delete
	     ;; 
	     t) 
	     	total_usage
	     ;; 
	     m) 
	        bash monitor.sh #or ./monitor.sh
	     ;; 
	     k) 
	     	kill_monitor_logs
	     ;;      
	     h) 
	     	manual
	     ;;
	    \?) manual;;
	  esac
	done

((pos = OPTIND - 1))
shift $pos

PS3='option> '

if (( $# == 0 ))
then if (( $OPTIND == 1 )) 
#Starter function display my name and ID and some information about the system.
starter
echo -e "$delimiter"
 then select menu_list in List-Files Recover Delete Total-Usage Monitor-Logs kill help exit
      do case $menu_list in
         "List-Files") 
         	list_files
         ;;
         "Recover") 
         	echo -n 'Enter file name: '
         	read input_file
         	recover $input_file 
         ;;
         "Delete") 
         	delete 
         ;;
         "Total-Usage") 
         	total_usage
         ;;
         "Monitor-Logs") 
             bash monitor.sh #or ./monitor.sh
         ;;
         "kill") 
         	kill_monitor_logs
         ;;
         "help") 
         	manual
         ;;
         "exit") 
         	exit 0
         ;;
         *) 
         	echo "Please enter a valid option !"
         ;;
         esac
      done
 fi
else delete_files $@
fi




