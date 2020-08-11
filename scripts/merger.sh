#!/bin/bash
# Author: M. Can Kandemir
# Email: cnkndmr@gmail.com

rm ../data/*/year_*.csv
rm ../data/*/year_*/race_*.csv
rm ../data/*/data.csv

for i in ../data/*/*
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
        if [ -d "$j" ]
        then
            race_id=$(echo "$j" | grep -o "race_.*")
            sed "s/^/\"$race_id\",/g" "$j".csv >> "$i".csv
        fi
    done
    if [ -d "$i" ]
    then
        year=$(echo "$i" | grep -o "year_.*")
        sed "s/^/\"$year\",/g" "$i".csv >> ../data/f1/data.csv
    fi
done

sed -i '1i\"race_year\",\"race_circuit\",\"lap\",\"driver\",\"position\",\"lap_time\"' ../data/f1/data.csv
