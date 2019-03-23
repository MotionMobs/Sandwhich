#!/bin/bash

if [[ -z $(which magick) ]]; then
  echo 'imagemagick not found -- please make sure it is installed!'
  exit
fi


for l in `find ./input/ -maxdepth 1 -mindepth 1 -type d | sed 's/.\/input\///g'`; do
  echo $l
  for i in ./input/$l/unprocessed/*; do
    if [[ ! -e $i ]]; then
      echo 'file does not exist'
      exit
    fi

    tmp='tmp.jpg'
    # resize and strip metadata out
    magick "$i" -strip -resize '224x224' $tmp
    # use md5 to protect minimally against duplicates
    name=$(md5 -q $tmp)
    # echo $name
    mv -f $tmp "$name.jpg"
    mv -f "$i" ./input/$l/processed/
  done

  # move all files to processed
  mkdir -p "./output/$l"
  mv -f *.jpg "./output/$l/"
done
