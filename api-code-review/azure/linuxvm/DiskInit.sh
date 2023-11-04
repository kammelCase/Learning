#!/bin/bash

# log file name
LOG_FILE="/var/log/disk-init.log"
# Parse arguments from terraform templatefile
DISK_INIT_ARGS=(${disk_init_args})

# logging
log() {
	LEVEL=$1
	MESSAGE=$2

	if [ -z "$MESSAGE" ]
	then
		read MESSAGE
	fi

	if [ $LEVEL == "ERROR" ]
	then
		echo "[$(date)] :: [ERROR] :: $MESSAGE" >&2 | tee -a $LOG_FILE
		exit $EXIT_CODE
	elif [ $LEVEL == "DEBUG" ]
	then
		echo "[$(date)] :: [DEBUG] :: $MESSAGE" | tee -a $LOG_FILE
	elif [ $LEVEL == "INFO" ]
	then
		echo "[$(date)] :: [INFO] :: $MESSAGE" | tee -a $LOG_FILE
	fi

}

usage() {
	echo "sudo $(basename $0)"
}

check_sudo_access() {
	if [ $(id -u) -ne 0 ]
	then
		log $? "Elevated sudo or root user access required to run this script."
		usage
		exit 1
	fi
}

do_partition() {
	DISK=$1
	PARTITIONS=$2

	partition_number=1
	fdisk_args=""
	for partition in $${PARTITIONS[@]}
	do
		partition_size=$(echo $partition | cut -d ',' -f 2 | cut -d '=' -f 2 | grep -o -E '[0-9]+')
		last_sector=$(( ($partition_size*2097152) - 2048 - 1  ))

		fdisk_args+="n\np\n$${partition_number}\n\n+$${last_sector}\n\n\n"

		partition_number=$(( $partition_number + 1 ))
	done

	log "INFO" "Partitioning the disk $DISK"
	fdisk_args+="p\nw\n"
	fdisk_stdout=$(echo -e "$fdisk_args" | fdisk $DISK)

	if [ $? -ne 0 ];
	then
		log "ERROR" "$fdisk_stdout"
		else
		log "DEBUG" "$fdisk_stdout"
		log "INFO" "The Disk $DISK partitioned successfully."
		fi

	partprobe $DISK

}

add_to_fstab() {
	UUID=$1
	MOUNT=$2
	log "INFO" "Adding UUID to /etc/fstab"
	grep "$UUID" /etc/fstab >/dev/null 2>&1
	if [ $? -eq 0 ];
	then
		log "DEBUG" "Not adding $UUID to fstab again (it's already there!)"
	else
		LINE="UUID=\"$UUID\"\t$MOUNT\text4\tnoatime,nodiratime,nodev,noexec,nosuid\t1 2"
		echo -e "$LINE" >> /etc/fstab
		log "INFO" "The UUID updated to fstab successfully."
	fi
}

is_partition_exist() {
	LUN=$1
	PARTITION=$2

	log "INFO" "Checking if partition $PARTITION exist"
	ls -la /dev/disk/azure/scsi1/ | grep lun$${LUN}-part$${PARTITION} >/dev/null 2>&1
	return $?

}

has_filesystem() {
	DISK=$1
	PARTITION=$2
	DISK=$DISK$PARTITION

	log "INFO" "Checking if filesystem exist for $DISK"
	OUTPUT=$(file -L -s $DISK)
	grep filesystem <<< "$OUTPUT" > /dev/null 2>&1
	return $?
}

has_mount() {
	DISK=$1
	PARTITION=$2
	DISK=$DISK$PARTITION

	log "INFO" "Checking if $DISK already mounted."
	lsblk "$DISK" | grep -v "NAME" | awk '{print $7}' | grep "/" >/dev/null 2>&1
	return $?
}


main() {

	# initialize logging
	# set default value for LOG_FILE
	if [ -z $LOG_FILE ]
	then
		LOG_FILE="/var/log/disk-init.log"
	fi

	# Create log file if not exist
	if [ ! -e $LOG_FILE ]
	then
		mkdir -p $(dirname $LOG_FILE)
		touch $LOG_FILE
	fi

	log "INFO" ">>> START "
	log "INFO" "Log File: $LOG_FILE"

	# Check sudo access
	log "INFO" "Checking sudo access"
	check_sudo_access

	# Extract lun numbers from DISK_INIT_ARGS to unique sorted values
	lun_numbers=""
	for dev in $${DISK_INIT_ARGS[@]}
	do
		lun_number=$(echo $dev | cut -d ',' -f 1 | cut -d '=' -f 2)
		lun_numbers+="$lun_number "
	done
	lun_numbers=($(echo $${lun_numbers[@]} | tr ' ' '\n' | sort -nu | tr '\n' ' '))

	log "INFO" "LUN Numbers: $${lun_numbers[@]}"


	# Group the DISK_INIT_ARGS as per lun into an array
	# Example: arg[0] will have all the partition arguments of lun=0
	declare -A args
	for lun_number in $${lun_numbers[@]}
	do
		args[$lun_number]=""
		for dev in $${DISK_INIT_ARGS[@]}
		do
			lun=$(echo $dev | cut -d ',' -f 1 | cut -d '=' -f 2)
			if [ $lun -eq $lun_number ]
			then
				args[$lun_number]+="$dev "
			fi
		done

	done


	# Perform tasks for each lun
	for lun in $${lun_numbers[@]}
	do

		# variables
		number_of_existing_partitions=$(( $(ls /dev/disk/azure/scsi1/ | grep lun$${lun} | wc -l) - 1 ))
		disk=$(readlink -f "/dev/disk/azure/scsi1/lun$${lun}")
		disk_size=$(lsblk $disk | grep -v NAME | awk '{print $4 }' | head -1 | grep -o -E '[0-9]+')

		# lun validation
		log "INFO" "Validating if lun $lun exist or not"
		ls -la /dev/disk/azure/scsi1/lun$lun >/dev/null 2>&1
		if [ $? -ne 0 ]
		then
			log "DEBUG" "The lun $lun do not exist in vm. The disk might not attached properly"
			continue
		else
			log "INFO" "The lun $lun exist in vm. continuing with tasks."
		fi

		# Calculate partitions size
		log "INFO" ">> Performing tasks on disk $disk"
		log "INFO" "Calculating total partition size of the disk $disk"
		total_partition_size=0
		for dev in $${args[$lun]}
		do
			partition_size=$(echo $dev | cut -d ',' -f 2 | cut -d '=' -f 2 | grep -o -E '[0-9]+')
			total_partition_size=$(( (($(echo $partition_size | grep -o -E '[0-9]+')*2097152) - 2049) + $total_partition_size ))
		done


		# validate partitions size
		log "INFO" "Validating partitions size of disk $disk"
		disk_size_sectors=$(( $disk_size*2097152 ))
		if [ $total_partition_size -gt $disk_size_sectors ]
		then
			log "ERROR" "Sum of all partitions size \"$total_partition_size sectors\" greater than the total disk size \"$disk_size_sectors sectors\""
		else
			log "INFO" "Total partitions size of the disk is \"$total_partition_size\" sectors."
		fi


		# Partitioning
		log "INFO" "Validating if partitions already exist for $disk"
		partition=1
		given_partitions=($${args[$lun]})
		number_of_given_partitions="$${#given_partitions[@]}"

		for dev in $${args[$lun]}
		do
			is_partition_exist $lun $partition
			if [ $? -eq 0 ]
			then
				log "INFO" "Partition $partition already exist, Skipping partition $partition."
				number_of_given_partitions=$(( $number_of_given_partitions - 1 ))
			else
				log "INFO" "Partition $partition do not exist, will creating new one."
			fi

			partition=$(( $partition + 1 ))
		done

		# Create partitions
		if [ $number_of_given_partitions -eq 0 ]
		then
			log "DEBUG" "There are no partitions left to create in $disk."
		else
			do_partition "$disk" "$${args[$lun]}"
		fi


		# Tasks per partition
		partition_number=1
		for dev in $${args[$lun]}
		do
			mount=$(echo "$dev" | cut -d ',' -f 3 | cut -d '=' -f 2)


			# File system format
			log "INFO" "Formatting filesystem of $disk$partition_number"
			log "INFO" "Validating if filesystem for $disk$partition_number already exist"
			has_filesystem $disk $partition_number
			if [ $? -eq 0 ]
			then
				log "INFO" "Filesystem for the partition $disk$partition_number is already exist"
				log "INFO" "Skipping filesystem formatting task"
			else
				log "INFO" "The filesystem do not exist for $disk$partition_number, So Formatting file system for $disk$partition_number"
				mkfs_stdout=$(mkfs -j -t "ext4" $disk$partition_number >/dev/null 2>&1)
				if [ $? -ne 0 ]
				then
					log "DEBUG" "Failed to format $disk$partition_number"
					log "DEBUG" "$mkfs_stdout"
				else
					log "INFO" "The $disk$partition_number Formatted successfully."
				fi
				wait
			fi

			# Mount
			log "INFO" "Mounting disk partition $disk$partition_number"
			log "INFO" "Validating if disk is already mounted"
			has_mount $disk $partition_number
			if [ $? -eq 0 ]
			then
				log "INFO" "Disk $disk$partition_number already mounted at $mount"
				log "INFO" "Skipping mount task"
			else
				log "INFO" "Disk $disk$partition_number has no mount"
				log "INFO" "Validating if mount directory exist"
				if ! [ -d "$mount" ]
				then
					log "INFO" "Creating mount directory"
					mkdir -p "$mount" >/dev/null 2&>1
				else
					log "INFO"  "Mount directory $mount already exists"
				fi
				read UUID FS_TYPE < <(blkid -u filesystem "$disk$partition_number" |awk -F "[= ]" '{print $3" "$5}'|tr -d "\"")
				wait
				add_to_fstab "$UUID" "$mount"
				wait
				log "INFO" "Mounting disk $disk$partition_number on $mount"
				mount_stdout=$(mount "$mount")
				if [ $? -eq 0 ]
				then
					log "INFO" "Mount successful."
				else
					log "DEBUG" "Failed to mount $mount"
					log "DEBUG" "$mount_stdout"
				fi
				wait
			fi

			sleep 5

			partition_number=$(( $partition_number + 1 ))
		done

	done

	log "INFO" ">>> END"
}

# Execute main
main