function flactomp3 {
  FFMETADATA="$(mktemp)"
  SAMPLEFILE="$(echo 01*.flac)"
  ffmpeg -i "$SAMPLEFILE" -f ffmetadata -y "$FFMETADATA"
  ARTIST="$(sed -e 's/^artist=\(.*\)/\1/Ip' --quiet $FFMETADATA)"
  ALBUM="$(sed -e 's/^album=\(.*\)/\1/Ip' --quiet $FFMETADATA)"
  [[ "${ARTIST}${ALBUM}z" == "z" ]] && {
    echo "Both artist and album are empty. Exiting." 
    return ;
  }

  function escapeFullAlbumName {
    echo $(printf '%q' "$ARTIST - $ALBUM") 
  }
  OUTPUTDIR="$(escapeFullAlbumName)"

  echo Creating "$ARTIST - $ALBUM"
  mkdir -p "$ARTIST - $ALBUM"
  for f in *.flac; do 
    ffmpeg -i "$f" -c:a libmp3lame -b:a 320k -map_metadata 0 "$ARTIST - $ALBUM/${f%.flac}.mp3"; 
  done
  cd "$ARTIST - $ALBUM" 
  rm $FFMETADATA
}

function split_cue_flac {
  shnsplit -f "$1" -o flac "$2" -t "%n - %t"
}
