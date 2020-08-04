#!/bin/bash
# Author: M. Can Kandemir
# Email: cnkndmr@gmail.com

for i in data/*
do
	for j in "$i"/*
	do
		for k in "$j"/*
		do
			if [ -f "$k" ]
			then
				lap_number=$(echo "$k" | grep -o "lap_.*\." | grep -Eo "[0-9]{1,2}")
				sed "s/^/\"$lap_number\",/g" "$k" >> "$j".csv
			fi
		done
		if [ -f "$j" ]
		then
			race_id=$(echo "$j" | grep -o "race_.*.csv" | sed 's/.csv//g')
			sed "s/^/\"$race_id\",/g" "$j" >> "$i".csv
		fi
	done
	if [ -f "$i" ]
	then
		year=$(echo "$i" | grep -o "year_.*.csv" | sed 's/.csv//g; s/\/\*//g')
		sed "s/^/\"$year\",/g" "$i" >> data.csv
	fi
done
