#!/bin/bash
# Author: M. Can Kandemir
# Email: cnkndmr@gmail.com

lap_info () {
	mkdir -p "../data/$5/year_$1/race_$(printf %02d "$2")_$4"
	curl "https://ergast.com/api/$5/$1/$2/laps/$3.json" | sed 's/{"driverId"/"\n{"driverId"/g; s/[{}]//g; s/\[//g; s/\]//g' | grep "\"driverId\"\:" | sed  's/"driverId"\://g; s/"position"\://g; s/"time"\://g; s/,"$//g' > "../data/$5/year_$1/race_$(printf %02d "$2")_$4/lap_$(printf %02d "$3").csv"
}

series="f1"

for year in {2019..2020}
do
	for round in {1..30}
	do
		raceId=$(curl "https://ergast.com/api/$series/$year/$round" | grep -o "circuitId=\".*\" " | grep -o "\".*\"" | sed 's/"//g')
		for lap in {1..100}
		do
			lap_info "$year" "$round" "$lap" "$raceId" "$series"
			if [ "$(du ../data/$series/year_"$year"/race_"$(printf %02d "$round")"_"$raceId"/lap_"$(printf %02d "$lap")".csv | cut -f 1)" -eq "0" ]
			then
				echo "Empty lap code break"
				rm ../data/"$series"/year_"$year"/race_"$(printf %02d "$round")"_"$raceId"/lap_"$(printf %02d "$lap")".csv
				break 1
			fi
		done
		if [ "$(ls ../data/"$series"/year_"$year"/race_"$(printf %02d "$round")"_"$raceId" | wc -l)" -eq "0" ]
			then
				echo "Empty race code break"
				rmdir ../data/"$series"/year_"$year"/race_"$(printf %02d "$round")"_"$raceId"
				break 1
			fi
	done
done
