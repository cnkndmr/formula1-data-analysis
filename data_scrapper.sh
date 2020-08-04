#!/bin/bash
# Author: M. Can Kandemir
# Email: cnkndmr@gmail.com

lap_info () {
	mkdir -p "data/year_$1/race_$2_$4"
	curl "https://ergast.com/api/f1/$1/$2/laps/$3.json" | sed 's/{"driverId"/"\n{"driverId"/g; s/[{}]//g; s/\[//g; s/\]//g' | grep "\"driverId\"\:" | sed  's/"driverId"\://g; s/"position"\://g; s/"time"\://g; s/,"$//g' > "data/year_$1/race_$2_$4/lap_$3.csv"
	
}

for i in {2019..2020}
do
	for j in {1..30}
	do
		raceId=$(curl "https://ergast.com/api/f1/$i/$j" | grep -o "circuitId=\".*\" " | grep -o "\".*\"" | sed 's/"//g')
		for k in {1..100}
		do
			lap_info "$i" "$j" "$k" "$raceId"
			if [ "$(du data/year_"$i"/race_"$j"_"$raceId"/lap_"$k".csv | cut -f 1)" -eq "0" ]
			then
				echo "Empty lap code break"
				rm data/year_"$i"/race_"$j"_"$raceId"/lap_"$k".csv
				break 1
			fi
		done
		if [ "$(ls data/year_"$i"/race_"$j"_"$raceId" | wc -l)" -eq "0" ]
			then
				echo "Empty race code break"
				rmdir data/year_"$i"/race_"$j"_"$raceId"
				break 1
			fi
	done
done
