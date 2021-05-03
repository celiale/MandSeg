#!/bin/sh


while getopts i: flag
do
    case "${flag}" in
        i) inputdir=${OPTARG};;
    esac
done

echo ${inputdir}

docker run --rm \
    -v /shiny-tooth/data/dcbia-filebrowser/${inputdir}:/app/Scans/$(basename ${inputdir}) \
    -v /shiny-tooth/data/dcbia-filebrowser/$(dirname ${inputdir}):/app/Output \
    mandseg:latest \
    /app/src/main.sh



