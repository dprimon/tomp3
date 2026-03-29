#!/bin/bash

function tomp3 
{
  maxProcesses=16
  extension="$1"
  metadataFile="$(mktemp)"
  sampleFile="$(echo 01*."$extension")"
  ffmpeg -i "$sampleFile" -f ffmetadata -y "$metadataFile"
  artist="$(sed -e 's/^artist=\(.*\)/\1/Ip' --quiet "$metadataFile")"
  album="$(sed -e 's/^album=\(.*\)/\1/Ip' --quiet "$metadataFile")"
  [[ "${artist}${album}z" == "z" ]] && 
  {
    echo "Both artist and album are empty. Exiting." 
    return ;
  }

  outputDir="$artist - $album"

  echo Creating "$outputDir"
  mkdir -p "$outputDir"
  numProcessesInPool=0;
  while read -r f;
  do 
    ((numProcessesInPool++ < maxProcesses)) || wait -n;
    ffmpeg -nostdin -i "$f" -threads 1 -c:a libmp3lame -b:a 320k -map_metadata 0 "$outputDir/${f%.$extension}.mp3" &
  done < <(find . -name "*.$extension" | grep '/[[:digit:]][[:digit:]]')
  wait
  rm "$metadataFile"
  cd "$outputDir" || exit
}


function split_cue_flac 
{
  shnsplit -f "$1" -o flac "$2" -t "%n - %t"
}
